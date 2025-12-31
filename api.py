import joblib
from db import db, cursor
import tensorflow as tf
import numpy as np
from PIL import Image
from flask import Blueprint, jsonify, request
from flask_bcrypt import Bcrypt
from flask_jwt_extended import create_access_token, get_jwt_identity, jwt_required
from google.auth.transport import requests
from google.oauth2 import id_token
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

load_model = tf.keras.models.load_model
img_to_array = tf.keras.preprocessing.image.img_to_array

api = Blueprint("api", __name__)
bcrypt = Bcrypt()

GOOGLE_CLIENT_ID = "152566724840-itl7926ncrk5pi4lhqtmqtpoaioe5cgr.apps.googleusercontent.com"

# Load model CNN
model = load_model("model/model_temantukang.keras")
labels = [
    "Retak Dinding",
    "Plafon Rusak",
    "Keramik Rusak",
    "Cat Mengelupas",
    "Kayu Kusen Lapuk",
    "Dinding Berjamur"
]

analisis_faktor = {
    "Retak Dinding": "Kerusakan terjadi karena fondasi mengalami penurunan tidak merata, getaran berulang, atau tekanan beban berlebih pada struktur dinding.",
    "Plafon Rusak": "Kerusakan plafon biasanya disebabkan oleh kebocoran atap, rembesan air AC, atau material plafon yang sudah rapuh dan tidak mampu menahan beban.",
    "Keramik Rusak": "Keramik retak atau terangkat dapat terjadi akibat permukaan lantai yang tidak rata, penurunan tanah, atau pemasangan awal yang kurang tepat.",
    "Cat Mengelupas": "Cat mengelupas umumnya dipicu oleh kelembaban tinggi, rembesan air, atau permukaan dinding yang tidak dibersihkan dengan baik sebelum pengecatan.",
    "Kayu Kusen Lapuk": "Kusen kayu dapat lapuk karena paparan air, kelembaban tinggi, atau serangan jamur dan rayap.",
    "Dinding Berjamur": "Dinding berjamur terjadi akibat kelembaban berlebih, ventilasi yang buruk, atau rembesan air."
}

# Load Model SVM untuk sentimen
svm_model = joblib.load('model/svm_model.pkl')
tfidf = joblib.load('model/tfidf_vectorizer.pkl')

def predict_sentiment(text):
    text_tfidf = tfidf.transform([text])
    result = svm_model.predict(text_tfidf)[0]
    return "positif" if result == 1 else "negatif"

# Content-Based Filtering untuk rekomendasi tukang
cursor.execute("SELECT * FROM tukang")
TUKANG_DATA = cursor.fetchall()

dokumen_tukang = [f"{t['keahlian']} {t['pengalaman']}" for t in TUKANG_DATA]
vectorizer = TfidfVectorizer()
TFIDF_MATRIX = vectorizer.fit_transform(dokumen_tukang)

@api.route("/api/rekomendasi", methods=["POST"])
@jwt_required()
def api_rekomendasi():
    data = request.get_json()
    jenis_kerusakan = data["jenis_kerusakan"]

    query_vec = vectorizer.transform([jenis_kerusakan])
    sim_scores = cosine_similarity(query_vec, TFIDF_MATRIX).flatten()

    rekomendasi = []
    for i, t in enumerate(TUKANG_DATA):
        if sim_scores[i] >= 0.1:
            rekomendasi.append({
                "id_tukang": t["id_tukang"],
                "nama": t["nama"],
                "keahlian": t["keahlian"],
                "pengalaman": t["pengalaman"],
                "rating": t.get("rating", 0),
                "foto": t.get("foto", "")
            })

    return jsonify({"status": "success", "data": rekomendasi})

@api.route('/api/review', methods=['POST'])
@jwt_required()
def add_review():
    try:
        data = request.get_json()
        user_id = get_jwt_identity()
        tukang_id = data.get('tukang_id')
        review_text = data.get('review_text')
        rating = data.get('rating')

        if user_id is None or tukang_id is None or not review_text or rating is None:
            return jsonify({"status": "error", "message": "Data tidak lengkap"}), 400

        rating = int(rating)
        sentiment = predict_sentiment(review_text)

        cursor.execute("""
            INSERT INTO review (user_id, tukang_id, review_text, sentiment, rating)
            VALUES (%s, %s, %s, %s, %s)
        """, (user_id, tukang_id, review_text, sentiment, rating))

        cursor.execute("""
            UPDATE tukang
            SET 
                rating = (
                    SELECT IFNULL(AVG(rating), 0)
                    FROM review WHERE tukang_id=%s
                ),
                jumlah_ulasan = (
                    SELECT COUNT(*) FROM review WHERE tukang_id=%s
                )
            WHERE id_tukang=%s
        """, (tukang_id, tukang_id, tukang_id))

        db.commit()

        return jsonify({
            "status": "success",
            "sentiment": sentiment
        }), 201

    except Exception as e:
        db.rollback()
        return jsonify({"status": "error", "message": str(e)}), 500

@api.route("/api/deteksi", methods=["POST"])
def api_deteksi():
    try:
        if "file" not in request.files:
            return jsonify({
                "status": "error",
                "message": "file gambar tidak ditemukan"
            }), 400

        file = request.files["file"]

        img = Image.open(file).convert("RGB")
        img = img.resize((128, 128))
        img = img_to_array(img) / 255.0
        img = np.expand_dims(img, axis=0)

        pred = model.predict(img)
        label_index = int(np.argmax(pred))
        confidence = float(np.max(pred) * 100)
        hasil = labels[label_index]

        return jsonify({
            "status": "success",
            "hasil": hasil,
            "confidence": round(confidence, 2),
            "analisis": analisis_faktor.get(hasil, "")
        })

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500
@api.route("/api/register", methods=["POST"])
def api_register():
    try:
        data = request.get_json()

        nama = data.get("nama")
        email = data.get("email")
        password = data.get("password")

        if not nama or not email or not password:
            return jsonify({
                "status": "error",
                "message": "Data tidak lengkap"
            }), 400

        cursor.execute("SELECT id_users FROM users WHERE email=%s", (email,))
        if cursor.fetchone():
            return jsonify({
                "status": "error",
                "message": "Email sudah terdaftar"
            }), 400

        hashed = bcrypt.generate_password_hash(password).decode('utf-8')

        cursor.execute("""
            INSERT INTO users (username, email, password, role, auth_provider)
            VALUES (%s, %s, %s, 'customer', 'local')
        """, (nama, email, hashed))
        db.commit()

        return jsonify({
            "status": "success",
            "message": "Registrasi berhasil"
        }), 201

    except Exception as e:
        db.rollback()
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

@api.route("/api/login", methods=["POST"])
def api_login():
    try:
        data = request.get_json(force=True)

        email = data.get("email")
        password = data.get("password")

        if not email or not password:
            return jsonify({
                "status": "error",
                "message": "Email dan password wajib diisi"
            }), 400

        cursor.execute(
            "SELECT * FROM users WHERE email=%s",
            (email,)
        )
        user = cursor.fetchone()

        if not user:
            return jsonify({
                "status": "error",
                "message": "Email tidak terdaftar"
            }), 401

        if not bcrypt.check_password_hash(user['password'], password):
            return jsonify({
                "status": "error",
                "message": "Password salah"
            }), 401

        access_token = create_access_token(identity=user['id_users'])

        return jsonify({
            "status": "success",
            "access_token": access_token,
            "user": {
                "id_users": user["id_users"],
                "username": user["username"],
                "email": user["email"],
                "role": user["role"]
            }
        })

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

@api.route('/api/auth/google', methods=['POST'])
def api_login_google():
    token = request.json.get('id_token')

    if not token:
        return jsonify({"error": "id_token wajib"}), 400

    try:
        idinfo = id_token.verify_oauth2_token(
            token,
            requests.Request(),
            GOOGLE_CLIENT_ID
        )

        if idinfo['aud'] != GOOGLE_CLIENT_ID:
            return jsonify({"error": "Audience mismatch"}), 401

        google_id = idinfo['sub']
        email = idinfo['email']
        username = idinfo.get('name', email.split('@')[0])

        cursor.execute(
            "SELECT * FROM users WHERE google_id=%s",
            (google_id,)
        )
        user = cursor.fetchone()

        if not user:
            cursor.execute(
                "SELECT * FROM users WHERE email=%s",
                (email,)
            )
            existing = cursor.fetchone()

            if existing:
                return jsonify({
                    "error": "Email sudah terdaftar dengan metode lain"
                }), 409

            cursor.execute("""
                INSERT INTO users
                (username, email, password, role, auth_provider, google_id)
                VALUES (%s,%s,NULL,'customer','google',%s)
            """, (username, email, google_id))
            db.commit()

            cursor.execute(
                "SELECT * FROM users WHERE google_id=%s",
                (google_id,)
            )
            user = cursor.fetchone()

        access_token = create_access_token(identity=user['id_users'])

        return jsonify({
            "status": "success",
            "access_token": access_token,
            "user": {
                "id_users": user["id_users"],
                "username": user["username"],
                "email": user["email"],
                "auth_provider": "google"
            }
        }), 200

    except ValueError:
        return jsonify({"error": "Token Google tidak valid"}), 401

# BUAT PESANAN (CUSTOMER)
@api.route("/api/pesanan", methods=["POST"])
@jwt_required()
def buat_pesanan():
    user_id = get_jwt_identity()
    data = request.get_json()

    cursor.execute("""
        INSERT INTO pesanan
        (user_id, tukang_id, nama_customer, tanggal_pengerjaan, alamat, harga_per_hari)
        VALUES (%s,%s,%s,%s,%s,%s)
    """, (
        user_id,
        data["tukang_id"],
        data["nama_customer"],
        data["tanggal_pengerjaan"],
        data["alamat"],
        data["harga_per_hari"]
    ))

    db.commit()
    return jsonify({
        "status": "success",
        "message": "Pesanan berhasil dibuat"
    }), 201

# HOMEPAGE CUSTOMER (PESANAN AKTIF)
@api.route("/api/customer/home", methods=["GET"])
@jwt_required()
def home_customer():
    user_id = get_jwt_identity()

    cursor.execute("""
        SELECT
            p.id_pesanan,
            t.nama AS nama_tukang,
            p.tanggal_pengerjaan,
            p.status,
            p.harga_per_hari
        FROM pesanan p
        JOIN tukang t ON p.tukang_id = t.id_tukang
        WHERE p.user_id=%s
          AND p.status != 'selesai'
        ORDER BY p.created_at DESC
    """, (user_id,))

    return jsonify({
        "status": "success",
        "data": cursor.fetchall()
    })

# RIWAYAT PESANAN CUSTOMER
@api.route("/api/customer/pesanan", methods=["GET"])
@jwt_required()
def riwayat_customer():
    user_id = get_jwt_identity()

    cursor.execute("""
        SELECT
            p.id_pesanan,
            t.nama AS nama_tukang,
            p.tanggal_pengerjaan,
            p.status,
            p.harga_per_hari,
            p.created_at
        FROM pesanan p
        JOIN tukang t ON p.tukang_id = t.id_tukang
        WHERE p.user_id=%s
        ORDER BY p.created_at DESC
    """, (user_id,))

    return jsonify({
        "status": "success",
        "data": cursor.fetchall()
    })

# DETAIL PESANAN (CUSTOMER – REALTIME STATUS)
@api.route("/api/pesanan/<int:id_pesanan>", methods=["GET"])
@jwt_required()
def detail_pesanan(id_pesanan):
    user_id = get_jwt_identity()

    cursor.execute("""
        SELECT
            p.*,
            t.nama AS nama_tukang
        FROM pesanan p
        JOIN tukang t ON p.tukang_id = t.id_tukang
        WHERE p.id_pesanan=%s
          AND p.user_id=%s
    """, (id_pesanan, user_id))

    data = cursor.fetchone()
    if not data:
        return jsonify({"status": "error", "message": "Pesanan tidak ditemukan"}), 404

    return jsonify({
        "status": "success",
        "data": data
    })

# HOMEPAGE TUKANG (PESANAN MASUK & BERJALAN)
@api.route("/api/tukang/home", methods=["GET"])
@jwt_required()
def home_tukang():
    tukang_id = get_jwt_identity()

    cursor.execute("""
        SELECT
            id_pesanan,
            nama_customer,
            alamat,
            tanggal_pengerjaan,
            harga_per_hari,
            status
        FROM pesanan
        WHERE tukang_id=%s
          AND status != 'selesai'
        ORDER BY created_at DESC
    """, (tukang_id,))

    return jsonify({
        "status": "success",
        "data": cursor.fetchall()
    })

# RIWAYAT PESANAN TUKANG
@api.route("/api/tukang/pesanan", methods=["GET"])
@jwt_required()
def riwayat_tukang():
    tukang_id = get_jwt_identity()

    cursor.execute("""
        SELECT *
        FROM pesanan
        WHERE tukang_id=%s
        ORDER BY created_at DESC
    """, (tukang_id,))

    return jsonify({
        "status": "success",
        "data": cursor.fetchall()
    })

# UPDATE STATUS (TOMBOL TUKANG)
@api.route("/api/pesanan/status", methods=["PUT"])
@jwt_required()
def update_status():
    tukang_id = get_jwt_identity()
    data = request.get_json()

    VALID_STATUS = [
        "menunggu_konfirmasi",
        "diterima",
        "ditolak",
        "menuju_lokasi",
        "dalam_pengerjaan",
        "selesai"
    ]

    if data["status"] not in VALID_STATUS:
        return jsonify({
            "status": "error",
            "message": "Status tidak valid"
        }), 400

    cursor.execute("""
        UPDATE pesanan
        SET status=%s
        WHERE id_pesanan=%s
          AND tukang_id=%s
    """, (
        data["status"],
        data["id_pesanan"],
        tukang_id
    ))

    db.commit()

    if cursor.rowcount == 0:
        return jsonify({
            "status": "error",
            "message": "Pesanan tidak ditemukan"
        }), 404

    return jsonify({
        "status": "success",
        "message": "Status pesanan diperbarui"
    })
