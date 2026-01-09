-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Waktu pembuatan: 06 Jan 2026 pada 04.44
-- Versi server: 8.0.30
-- Versi PHP: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `capstone_web`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `chat`
--

CREATE TABLE `chat` (
  `id_chat` int NOT NULL,
  `pesanan_id` int NOT NULL,
  `sender` enum('customer','tukang') NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pesanan`
--

CREATE TABLE `pesanan` (
  `id_pesanan` int NOT NULL,
  `user_id` int NOT NULL,
  `tukang_id` int NOT NULL,
  `nama_customer` varchar(100) NOT NULL,
  `tanggal_pengerjaan` date NOT NULL,
  `alamat` text NOT NULL,
  `harga_per_hari` int NOT NULL,
  `status` enum('menunggu_konfirmasi','diterima','ditolak','menuju_lokasi','dalam_pengerjaan','selesai') DEFAULT 'menunggu_konfirmasi',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data untuk tabel `pesanan`
--

INSERT INTO `pesanan` (`id_pesanan`, `user_id`, `tukang_id`, `nama_customer`, `tanggal_pengerjaan`, `alamat`, `harga_per_hari`, `status`, `created_at`) VALUES
(1, 10, 3, 'Customer', '2026-01-03', 'tghj', 250000, 'menunggu_konfirmasi', '2026-01-03 05:22:25'),
(2, 10, 3, 'Customer', '2026-01-16', 'tvyvu', 300000, 'menunggu_konfirmasi', '2026-01-03 05:24:07'),
(3, 10, 3, 'Customer', '2026-01-15', 'cucu', 250000, 'menunggu_konfirmasi', '2026-01-03 05:32:49'),
(4, 10, 3, 'Customer', '2026-01-22', 'hhhn', 300000, 'menunggu_konfirmasi', '2026-01-03 05:48:30'),
(5, 10, 4, 'Customer', '2026-01-29', 'p', 250000, 'selesai', '2026-01-03 06:05:58'),
(6, 10, 3, 'Customer', '2026-01-04', 'hshbsbsb', 250000, 'menunggu_konfirmasi', '2026-01-03 06:51:54'),
(7, 10, 4, 'Customer', '2026-01-12', 'hehbs\n', 250000, 'menunggu_konfirmasi', '2026-01-03 07:00:00'),
(8, 10, 4, 'Customer', '2026-01-12', 'uhbnnv\n', 300000, 'selesai', '2026-01-03 07:01:15'),
(9, 10, 4, 'Customer', '2026-01-14', 'fghj', 1000, 'diterima', '2026-01-03 07:01:46'),
(10, 10, 4, 'Customer', '2026-01-31', 'JALAN HALAN', 123, 'selesai', '2026-01-03 10:27:24'),
(11, 10, 3, 'Customer', '2026-01-05', 'n', 250000, 'selesai', '2026-01-05 08:34:25'),
(12, 10, 3, 'Customer', '2026-01-13', 'sata', 250000, 'selesai', '2026-01-05 09:34:28');

-- --------------------------------------------------------

--
-- Struktur dari tabel `review`
--

CREATE TABLE `review` (
  `id_review` int NOT NULL,
  `user_id` int NOT NULL,
  `tukang_id` int NOT NULL,
  `review_text` text NOT NULL,
  `sentiment` varchar(20) DEFAULT NULL,
  `rating` int NOT NULL,
  `tanggal` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data untuk tabel `review`
--

INSERT INTO `review` (`id_review`, `user_id`, `tukang_id`, `review_text`, `sentiment`, `rating`, `tanggal`) VALUES
(1, 1, 2, 'Tukangnya cepat, rapi, dan hasilnya bagus', 'positif', 5, '2025-12-14 23:49:52'),
(2, 1, 2, 'Lambat kerjanya', 'negatif', 2, '2025-12-15 00:09:34'),
(12, 10, 3, 'bagus', 'positif', 5, '2026-01-05 10:23:38'),
(13, 10, 3, 'capat', 'negatif', 3, '2026-01-05 10:40:31');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tukang`
--

CREATE TABLE `tukang` (
  `id_tukang` int NOT NULL,
  `id_users` int DEFAULT NULL,
  `nama` varchar(100) NOT NULL,
  `keahlian` text NOT NULL,
  `pengalaman` text,
  `foto` varchar(255) DEFAULT NULL,
  `rating` decimal(3,2) DEFAULT '0.00',
  `jumlah_ulasan` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data untuk tabel `tukang`
--

INSERT INTO `tukang` (`id_tukang`, `id_users`, `nama`, `keahlian`, `pengalaman`, `foto`, `rating`, `jumlah_ulasan`) VALUES
(1, 11, 'Ahmad Imam ', 'Tukang Dinding, Tukang Plafon', 'Perbaikan Dinding, Renovasi Rumah, Perbaikan Plafon', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(2, 12, 'Budi Santoso', 'Tukang Keramik', 'Pemasangan Keramik, Pengecatan, Renovasi Interior', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 4.55, 11),
(3, 62, 'Cahyo Dewanto', 'Tukang Plafon, Tukang Cat, Tukang Dinding', 'Perbaikan Plafon, Renovasi Rumah, Pemasangan Lampu', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 4.00, 2),
(4, 63, 'Dedi Pratama', 'Tukang Dinding, Tukang Cat', 'Perbaikan Dinding, Pengecatan Interior, Renovasi Rumah', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(5, 64, 'Eko Putra', 'Tukang Keramik, Tukang Plafon', 'Pemasangan Keramik, Perbaikan Plafon, Renovasi Lantai', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(6, 65, 'Fajar Hidayat', 'Tukang Dinding', 'Perbaikan Dinding, Pemasangan Keramik, Pekerjaan Interior', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(7, 66, 'Gilang Ramadhan', 'Tukang Plafon, Tukang Cat', 'Perbaikan Plafon, Pengecatan Interior, Renovasi Rumah', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(8, 67, 'Hendra Saputra', 'Tukang Dinding', 'Perbaikan Dinding, Renovasi Rumah, Pekerjaan Eksterior', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(9, 68, 'Iqbal Lestari', 'Tukang Keramik, Tukang Plafon', 'Pemasangan Keramik, Perbaikan Plafon, Renovasi Lantai', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(10, 69, 'Kevin Maulana', 'Tukang Plafon', 'Perbaikan Plafon, Pekerjaan Interior, Pemasangan Lampu', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(11, 70, 'Lutfi Maulana', 'Tukang Keramik, Tukang Dinding', 'Pemasangan Keramik, Perbaikan Dinding, Renovasi Lantai', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(12, 71, 'Muhammad Safitri', 'Tukang Cat, Tukang Plafon', 'Pengecatan Interior, Perbaikan Plafon, Renovasi Rumah', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(13, 72, 'Nanda Prasetyo', 'Tukang Keramik, Tukang Dinding', 'Perbaikan Atap, Pemasangan Keramik, Renovasi Lantai', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(14, 73, 'Oki Santika', 'Tukang Dinding, Tukang Cat', 'Perbaikan Dinding, Pengecatan, Renovasi Interior', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(15, 74, 'Putra Anggraini', 'Tukang Plafon, Tukang Keramik', 'Perbaikan Plafon, Pemasangan Keramik, Renovasi Rumah', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(16, 75, 'Qori Ahmad', 'Tukang Dinding, Tukang Plafon', 'Perbaikan Atap, Perbaikan Dinding, Pekerjaan Eksterior', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(17, 76, 'Rizki Fadhil', 'Tukang Cat, Tukang Keramik', 'Pengecatan Interior, Pemasangan Keramik, Renovasi Lantai', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(18, 77, 'Sandi Handayani', 'Tukang Plafon, Tukang Cat', 'Perbaikan Plafon, Perbaikan Atap, Renovasi Rumah', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(19, 78, 'Teguh Prabowo', 'Tukang Dinding, Tukang Keramik', 'Perbaikan Dinding, Pemasangan Keramik, Renovasi Interior', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(20, 79, 'Umar Salma', 'Tukang Cat, Tukang Plafon', 'Pengecatan Interior, Perbaikan Plafon, Renovasi Rumah', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(21, 80, 'Vino Aditya', 'Tukang Dinding, Tukang Keramik, Tukang Cat', 'Perbaikan Dinding, Pemasangan Keramik, Pengecatan Interior', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(22, 81, 'Wira Cahya', 'Tukang Plafon, Tukang Dinding', 'Perbaikan Plafon, Perbaikan Dinding, Renovasi Rumah', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(23, 82, 'Xavier Pratama', 'Tukang Cat, Tukang Keramik', 'Pemasangan Keramik, Pengecatan, Renovasi Lantai', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(24, 83, 'Yusuf Astuti', 'Tukang Plafon, Tukang Dinding', 'Perbaikan Plafon, Renovasi Dinding, Renovasi Rumah', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(25, 84, 'Zaki Fauzan', 'Tukang Dinding, Tukang Keramik', 'Perbaikan Dinding, Pemasangan Keramik, Renovasi Interior', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(26, 85, 'Agus Putra', 'Tukang Cat, Tukang Plafon', 'Pengecatan, Perbaikan Plafon, Renovasi Rumah', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(27, 86, 'Bima Santoso', 'Tukang Dinding, Tukang Plafon, Tukang Cat', 'Perbaikan Dinding, Perbaikan Plafon, Pengecatan Interior', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(28, 87, 'Cahyo Lestari', 'Tukang Keramik, Tukang Plafon', 'Pemasangan Keramik, Perbaikan Plafon, Renovasi Lantai', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(29, 88, 'Doni Amelia', 'Tukang Cat, Tukang Dinding', 'Pengecatan, Perbaikan Dinding, Renovasi Rumah', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(30, 89, 'Eko Wibowo', 'Tukang Plafon, Tukang Cat', 'Perbaikan Plafon, Renovasi Rumah, Pemasangan Lampu', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(31, 90, 'Farhan Nabila', 'Tukang Dinding, Tukang Keramik', 'Perbaikan Dinding, Pemasangan Keramik, Renovasi Interior', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(32, 91, 'Gilang Prasetyo', 'Tukang Cat, Tukang Plafon', 'Pengecatan, Perbaikan Plafon, Renovasi Rumah', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(33, 92, 'Hadi Salsabila', 'Tukang Keramik, Tukang Dinding', 'Perbaikan Atap, Pemasangan Keramik, Renovasi Lantai', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(34, 93, 'Irwan Saputra', 'Tukang Dinding, Tukang Plafon', 'Perbaikan Dinding, Perbaikan Plafon, Renovasi Rumah', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(35, 94, 'Johan Anggraini', 'Tukang Keramik, Tukang Cat', 'Pemasangan Keramik, Pengecatan, Renovasi Lantai', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(36, 95, 'Kevin Pratama', 'Tukang Plafon, Tukang Cat', 'Perbaikan Plafon, Perbaikan Atap, Renovasi Rumah', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(37, 96, 'Lutfi Putra', 'Tukang Dinding, Tukang Keramik, Tukang Cat', 'Perbaikan Dinding, Pemasangan Keramik, Renovasi Interior', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(38, 97, 'Miko Rahman', 'Tukang Cat, Tukang Plafon', 'Pengecatan, Perbaikan Plafon, Renovasi Rumah', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(39, 98, 'Nanda Safitri', 'Tukang Dinding, Tukang Plafon', 'Perbaikan Atap, Perbaikan Dinding, Renovasi Lantai', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(40, 99, 'Omar Fauzan', 'Tukang Keramik, Tukang Plafon, Tukang Cat', 'Pemasangan Keramik, Perbaikan Plafon, Renovasi Lantai', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(41, 100, 'Putra Maharani', 'Tukang Cat, Tukang Dinding', 'Pengecatan, Perbaikan Dinding, Renovasi Interior', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(42, 101, 'Qomarudin', 'Tukang Plafon, Tukang Cat', 'Perbaikan Plafon, Perbaikan Atap, Renovasi Rumah', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(43, 102, 'Rian Ayu', 'Tukang Dinding, Tukang Keramik', 'Perbaikan Dinding, Pemasangan Keramik, Renovasi Lantai', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(44, 103, 'Sandy Pratama', 'Tukang Cat, Tukang Plafon', 'Pengecatan, Perbaikan Plafon, Renovasi Rumah', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(45, 104, 'Tegar Maharani', 'Tukang Keramik, Tukang Dinding', 'Perbaikan Atap, Pemasangan Keramik, Renovasi Lantai', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(46, 105, 'Umar Hadi', 'Tukang Dinding, Tukang Plafon, Tukang Cat', 'Perbaikan Dinding, Perbaikan Plafon, Renovasi Rumah', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0),
(47, 106, 'Vito Lestari', 'Tukang Keramik, Tukang Cat', 'Pemasangan Keramik, Pengecatan, Renovasi Interior', 'https://pengadaan.or.id/wp-content/uploads/2023/10/tukang-bangunan-1.jpg', 0.00, 0);

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id_users` int NOT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `role` enum('admin','customer','tukang') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'customer',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `google_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `auth_provider` enum('local','google') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'local'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id_users`, `username`, `email`, `password`, `role`, `created_at`, `updated_at`, `google_id`, `auth_provider`) VALUES
(1, 'aku', 'aku@gmail.com', '123456', 'customer', '2025-12-03 10:49:53', '2025-12-03 10:49:53', NULL, 'local'),
(2, 'admin', 'admin@gmail.com', '123456', 'admin', '2025-12-05 05:09:36', '2025-12-05 05:09:36', NULL, 'local'),
(5, 'dinda', 'dinda@gmail.com', '$2y$10$A55PVl6RQMZUV93dJYd2zufzTlCHDZcwznwH5ZfuNdggxP.mGii3.', 'customer', '2025-12-17 09:14:56', '2025-12-17 09:14:56', NULL, 'local'),
(6, 'adam', 'adam@gmail.com', '$2y$10$FwkFIShwi2peKQ7ZeyB0F.2F6dHGUjibUt5ZiB6zRcs3N7PSMd6D.', 'customer', '2025-12-18 05:58:50', '2025-12-18 05:58:50', NULL, 'local'),
(7, 'Test User', 'test@mail.com', '123456', 'customer', '2025-12-18 07:42:42', '2025-12-18 07:42:42', NULL, 'local'),
(9, 'adam1', 'adamhawa@gmail.com', 'Adamhawa123', 'customer', '2025-12-18 07:54:43', '2025-12-30 09:54:53', NULL, 'local'),
(10, 'Septiyan Adam Maulana', 'miqdadfauz@gmail.com', NULL, 'customer', '2025-12-25 03:25:03', '2025-12-25 03:25:03', '109572864759829825129', 'google'),
(11, 'Ahmad Imam', 'ahmad@tukang.com', '$2b$12$PjZr4cjbOs1OT0HbxVQFveeRgrV7lRjekeVOL3bMURBz7sdaRZi1W', 'tukang', '2025-12-26 07:15:16', '2026-01-02 14:11:08', NULL, 'local'),
(12, 'Budi Santoso', 'budi@tukang.com', '$2b$12$Xh7ghVcX.2wzvLf1iZP/suQ0JExXaVZjtIivbveRtlnhqsZ4OKhcW', 'tukang', '2025-12-26 07:15:16', '2026-01-02 14:11:08', NULL, 'local'),
(62, 'Cahyo Dewanto', 'cahyodewanto@tukang.com', '$2b$12$cxtDkjzcSKaAD/qktdkCceZQ/Gujii4cBqfFLqRjqs6psvI..g3o.', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:09', NULL, 'local'),
(63, 'Dedi Pratama', 'dedip@tukang.com', '$2b$12$kOUkTfNYaxgr5AOUKecWpeZ.QqafImj8X17i3otq6ws4SefXhj8O.', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:09', NULL, 'local'),
(64, 'Eko Putra', 'ekoputra@tukang.com', '$2b$12$yxv4nL2kLSMAFneUlnHOTOvx5SxMRjWR8N1eGVjsJHeX4VxOi8u1.', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:10', NULL, 'local'),
(65, 'Fajar Hidayat', 'fajarhidayat@tukang.com', '$2b$12$sH8UZ2TpqMhSeWtG5qfjBelCF5WL1kEaU41cxsr3eORdPq8egsTTm', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:10', NULL, 'local'),
(66, 'Gilang Ramadhan', 'gilangramadhan@tukang.com', '$2b$12$4khduLxJKVUdsyyje3tGgewD4Vybb1wKcBYgs9/VKrDdCpEaWugju', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:11', NULL, 'local'),
(67, 'Hendra Saputra', 'hendrasaputra@tukang.com', '$2b$12$svVEjMAroVElUHjJ7ZMP0uvrbqvvX1pgspfMlgcxtXy68tXWRWe1y', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:11', NULL, 'local'),
(68, 'Iqbal Lestari', 'iqballestari@tukang.com', '$2b$12$ameDNyznD3VHauYiewh.XusoziZgTyTdrHxtfqXfEPs8Xw6dtsLXC', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:12', NULL, 'local'),
(69, 'Kevin Maulana', 'kevinmaulana@tukang.com', '$2b$12$GXzxAdEgDrTtpOLeodHsBOnZVti7p39wMteXL6ApeY0N0B2PYv6Je', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:12', NULL, 'local'),
(70, 'Lutfi Maulana', 'lutfimaulana@tukang.com', '$2b$12$6/lfFjZjAnOayy4hM7aS9uYDWxZhHssQVj98iuan440Anc4XnxS5u', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:13', NULL, 'local'),
(71, 'Muhammad Safitri', 'muhammadsafitri@tukang.com', '$2b$12$tX2MSKAwAmINk14WQZlV2OgOFRnh/N0/YTSGgZJjlAtS6TEiOfR/W', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:13', NULL, 'local'),
(72, 'Nanda Prasetyo', 'nandaprasetyo@tukang.com', '$2b$12$z34HLhFZBU1Mcv5nTKb.OuZuaZeQ.6eFaI3v/s5I3gR/y94XN0fTK', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:14', NULL, 'local'),
(73, 'Oki Santika', 'okisantika@tukang.com', '$2b$12$89hX6uIH6wd0uGjZmm6Jn.GF5Hk.v3Fm3XKW3ru3EcK3xXmjisUWq', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:14', NULL, 'local'),
(74, 'Putra Anggraini', 'putraanggraini@tukang.com', '$2b$12$kGnCcKd1kbezI2ub3yMVpOt9zEPTo9m8/k7WSpK5EslyNXnexi1LW', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:15', NULL, 'local'),
(75, 'Qori Ahmad', 'qoriahmad@tukang.com', '$2b$12$GLKREpVwiVfptzJWtP4yH.riLXUGAGJNNoRAViiid.say9nl6c7uq', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:15', NULL, 'local'),
(76, 'Rizki Fadhil', 'rizkifadhil@tukang.com', '$2b$12$CmYAYQFxQx5FIABlCmDiQeScrf5pCckPTzIDQslRDWVVg8Q8o5KfW', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:16', NULL, 'local'),
(77, 'Sandi Handayani', 'sandihandayani@tukang.com', '$2b$12$J5cMkNHRLN9Q9vJEmSqBy.cV5.tt2kUirhumxVPb4GTSUIzD8Q4De', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:16', NULL, 'local'),
(78, 'Teguh Prabowo', 'teguhprabowo@tukang.com', '$2b$12$8MlC8.Yeo0bSM9fBwt3O0uY6pEzaQDJE/.SGj2iATMMsDhdy/4YaS', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:17', NULL, 'local'),
(79, 'Umar Salma', 'umarsalma@tukang.com', '$2b$12$GtDdHc4VbtoZMctuwgsLye2LzyDTDz5NifuS8b//USbXv5BF1TfjW', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:17', NULL, 'local'),
(80, 'Vino Aditya', 'vinoditya@tukang.com', '$2b$12$4toJvXTpELndAJTjiH5nOeMqWjhRmIVNomeiANCKqfFAmPMtCvKL6', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:17', NULL, 'local'),
(81, 'Wira Cahya', 'wiracahya@tukang.com', '$2b$12$9RLcNfglDW4wH7BWM34GUe0Vkux6B3dp1nsimjigi1zinY1xsDOFq', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:18', NULL, 'local'),
(82, 'Xavier Pratama', 'xavierpratama@tukang.com', '$2b$12$ppGqBV.xCBFV4lT8XmK8XextPLinFp.6w7CHMsnlvT2mEeIgEaMhy', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:18', NULL, 'local'),
(83, 'Yusuf Astuti', 'yusufastuti@tukang.com', '$2b$12$ieeZCWstL/A/yTJqvbKUNu9Qz4Rfdv/gsV.OZnKvclnGjpTY8JZZ2', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:19', NULL, 'local'),
(84, 'Zaki Fauzan', 'zakifauzan@tukang.com', '$2b$12$7knEZgaHndaypU7eJnla4ONFV7l7o4E8exw03dW4Wakbo3NMZPGx2', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:19', NULL, 'local'),
(85, 'Agus Putra', 'agusputra@tukang.com', '$2b$12$nwUw69pB0sYVPxcfNZ0oSONYi2IJW2Zfm5.aq.hVUwkml.Aw2cufS', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:20', NULL, 'local'),
(86, 'Bima Santoso', 'bimasantoso@tukang.com', '$2b$12$6/E8NS/X2nAebCJkmAYQluEfezAxnNrJBMmjdozEo95r0kP6MA6Sa', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:20', NULL, 'local'),
(87, 'Cahyo Lestari', 'cahyolestari@tukang.com', '$2b$12$0hjKGRTHY6JqPo3qdRMjAuC8QD/AxrCSdCNp01XPMREy2vPGeQ1gG', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:21', NULL, 'local'),
(88, 'Doni Amelia', 'doniamelia@tukang.com', '$2b$12$374f3fcSnXoOsHD76ECHZeAtbTrcB1DtMRrDWSo/R7rHtDynR102u', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:21', NULL, 'local'),
(89, 'Eko Wibowo', 'ekowibowo@tukang.com', '$2b$12$MTU6ZnbsO6B8ltowhy9Di.r2aAm6hSOHHsUaUY39VpFTksMPecfaS', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:22', NULL, 'local'),
(90, 'Farhan Nabila', 'farhannabila@tukang.com', '$2b$12$XF/OMhJyDzBZmNaQ18NmOOYx2zxRaaU49NiE7kQJduiVRBcojgO.S', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:22', NULL, 'local'),
(91, 'Gilang Prasetyo', 'gilangprasetyo@tukang.com', '$2b$12$eiqHtGhwLInUVXw1qHFtqulfyAoIrNeINBmNi.zV4Kdx3WNmfFs7C', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:23', NULL, 'local'),
(92, 'Hadi Salsabila', 'hadisalsabila@tukang.com', '$2b$12$Ld0GtsCY.zIR1vOq50b5WugZx8cyajpk9UcjNa6SPQFQ1LEgak9MG', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:24', NULL, 'local'),
(93, 'Irwan Saputra', 'irwansaputra@tukang.com', '$2b$12$y1R31on3wgCKQPQv7PogOuPocEqzrGaWpBdm8OtfHzgTnWplSncCW', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:24', NULL, 'local'),
(94, 'Johan Anggraini', 'johananggraini@tukang.com', '$2b$12$JdwRNJ.LxKsFa3TXn9K11eybYn9RQ9BB8v4pLRgBsOmcBYGcf1RfG', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:25', NULL, 'local'),
(95, 'Kevin Pratama', 'kevinpratama@tukang.com', '$2b$12$vknPx55gopp/g5UWhvkSKOTbQ4F./6hteIjEOXG48yeVnVfk3njRG', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:25', NULL, 'local'),
(96, 'Lutfi Putra', 'lutfiputra@tukang.com', '$2b$12$z5Wq6dEwMQPaIDEgWTD8luRzRstnrcd4aXtXdteEBLi1XsGlTMn56', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:26', NULL, 'local'),
(97, 'Miko Rahman', 'mikorahman@tukang.com', '$2b$12$X76ei071E8hjK/TzPBEkoOsvZF3AkuhwgYvG.niJVSqyQ31gUO.r6', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:26', NULL, 'local'),
(98, 'Nanda Safitri', 'nandasafitri@tukang.com', '$2b$12$aK9cjZmjoIxgoLjmgU7B1u6wuTewtDXY.5jmL4IxSuhfV6NKCL/6y', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:27', NULL, 'local'),
(99, 'Omar Fauzan', 'omarfauzan@tukang.com', '$2b$12$nD7UwGI2Nr7dKU2.F3qR1.ADyhi9AZYbnMCTkNGj6LM4zkoqMaPSW', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:27', NULL, 'local'),
(100, 'Putra Maharani', 'putramaharani@tukang.com', '$2b$12$PLv6q8uZvMjNF72ThscugOiqi2vDlDVFb.FN/IvKOa3IlEHu6Ec66', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:28', NULL, 'local'),
(101, 'Qomarudin', 'qomarudin@tukang.com', '$2b$12$UUkUJtFfGKgMEoT4rbmlcOghMwJtyanGfy2xHB/6xX5KHCx/jaq/q', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:28', NULL, 'local'),
(102, 'Rian Ayu', 'rianayu@tukang.com', '$2b$12$ozZ9Ii21YNRUv8Jv7YZ3uOdYth0zWBFYlUSP1cgU1ImqiBwGC2gYG', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:29', NULL, 'local'),
(103, 'Sandy Pratama', 'sandypratama@tukang.com', '$2b$12$.CC.aU3rOxwy8T454fbDT.te8fzoWhcM52/gOY7Jw6CR9eBqu412O', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:29', NULL, 'local'),
(104, 'Tegar Maharani', 'tegarmarhani@tukang.com', '$2b$12$D6pYMpLBQp0RKOdhJWvgc.EpNG9YRuxrzU0pa38eV15xXn/GcUEd.', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:30', NULL, 'local'),
(105, 'Umar Hadi', 'umarhadi@tukang.com', '$2b$12$pyW5Bk9D/S00upxKcgLgreDu4V9XAQWil.zSResImRv8yTDpQOSQG', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:30', NULL, 'local'),
(106, 'Vito Lestari', 'vitolestari@tukang.com', '$2b$12$ybH57iGqcSL2RztI080jX.BUUkwrW.jLctNWx8gaZ4ADFONqdPIPC', 'tukang', '2025-12-28 07:09:39', '2026-01-02 14:11:31', NULL, 'local'),
(111, 'asep', 'asep@gmail.com', '$2b$12$lUtfyEEJmPCYYaVxmFrGC.4jUV5fZxeNiIEmYzaM25Fc734oXz2jW', 'customer', '2026-01-01 08:09:12', '2026-01-01 08:09:12', NULL, 'local'),
(113, 'ASEP123', 'ASEP123@gmail.com', '$2b$12$4ciu/xV1M1Wgm2UvBRItoOIKvE.S.mK00TqN3B8RnY7e.q6x5Oite', 'customer', '2026-01-02 08:44:23', '2026-01-02 08:44:23', NULL, 'local'),
(114, 'iyupgaming', 'iyup@gmail.com', '$2b$12$QsKuY2rcZIX6uIdbBt/wYOGccGpm.dlnmu1kCsZFrACC3DSgeBIuC', 'customer', '2026-01-02 09:13:05', '2026-01-02 09:13:05', NULL, 'local'),
(115, 'TESTING KE 30', 'TESTING30@gmail.com', '$2b$12$G5fG9lF4XP0zrTmNINGVpuCjMSOzidpLswoaIY.USwO7sX0upqLF2', 'customer', '2026-01-02 09:19:24', '2026-01-02 09:19:24', NULL, 'local'),
(116, 'testing', 'testing31@gmail.com', '$2b$12$As6EpZJVmRgkQtZA65JF9Ona8zeCLTbzrZ7S0Biia2ELdJwDpTwo.', 'customer', '2026-01-02 09:33:24', '2026-01-02 09:33:24', NULL, 'local');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `chat`
--
ALTER TABLE `chat`
  ADD PRIMARY KEY (`id_chat`),
  ADD KEY `pesanan_id` (`pesanan_id`);

--
-- Indeks untuk tabel `pesanan`
--
ALTER TABLE `pesanan`
  ADD PRIMARY KEY (`id_pesanan`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `tukang_id` (`tukang_id`);

--
-- Indeks untuk tabel `review`
--
ALTER TABLE `review`
  ADD PRIMARY KEY (`id_review`),
  ADD KEY `fk_review_user` (`user_id`),
  ADD KEY `fk_review_tukang` (`tukang_id`);

--
-- Indeks untuk tabel `tukang`
--
ALTER TABLE `tukang`
  ADD PRIMARY KEY (`id_tukang`),
  ADD UNIQUE KEY `id_users` (`id_users`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id_users`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `google_id` (`google_id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `chat`
--
ALTER TABLE `chat`
  MODIFY `id_chat` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `pesanan`
--
ALTER TABLE `pesanan`
  MODIFY `id_pesanan` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT untuk tabel `review`
--
ALTER TABLE `review`
  MODIFY `id_review` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT untuk tabel `tukang`
--
ALTER TABLE `tukang`
  MODIFY `id_tukang` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id_users` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=117;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `chat`
--
ALTER TABLE `chat`
  ADD CONSTRAINT `chat_ibfk_1` FOREIGN KEY (`pesanan_id`) REFERENCES `pesanan` (`id_pesanan`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `pesanan`
--
ALTER TABLE `pesanan`
  ADD CONSTRAINT `pesanan_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id_users`),
  ADD CONSTRAINT `pesanan_ibfk_2` FOREIGN KEY (`tukang_id`) REFERENCES `tukang` (`id_tukang`);

--
-- Ketidakleluasaan untuk tabel `review`
--
ALTER TABLE `review`
  ADD CONSTRAINT `fk_review_tukang` FOREIGN KEY (`tukang_id`) REFERENCES `tukang` (`id_tukang`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_review_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id_users`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `tukang`
--
ALTER TABLE `tukang`
  ADD CONSTRAINT `fk_tukang_users` FOREIGN KEY (`id_users`) REFERENCES `users` (`id_users`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
