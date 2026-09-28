-- ============================================================
-- GENERATE 1000 DATA DUMMY PERPUSTAKAAN DIGITAL
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;

-- Hapus temporary table jika ada (untuk menghindari error)
DROP TEMPORARY TABLE IF EXISTS _nama_depan;
DROP TEMPORARY TABLE IF EXISTS _nama_belakang;

-- Buat temporary tables
CREATE TEMPORARY TABLE _nama_depan (id INT PRIMARY KEY AUTO_INCREMENT, nama VARCHAR(30));
CREATE TEMPORARY TABLE _nama_belakang (id INT PRIMARY KEY AUTO_INCREMENT, nama VARCHAR(30));

-- Isi nama depan (50 nama Indonesia)
INSERT INTO _nama_depan (nama) VALUES 
('Andi'),('Budi'),('Citra'),('Dewi'),('Eko'),('Fitri'),('Gita'),('Hendra'),('Indah'),('Joko'),
('Kartika'),('Lina'),('Maya'),('Nina'),('Oki'),('Putri'),('Rina'),('Sari'),('Tono'),('Umi'),
('Vina'),('Wahyu'),('Yanti'),('Zaki'),('Ahmad'),('Bambang'),('Cahyo'),('Dian'),('Erna'),('Farid'),
('Guntur'),('Hani'),('Ivan'),('Juli'),('Kiki'),('Lukman'),('Mega'),('Nanda'),('Oscar'),('Prita'),
('Rendi'),('Sinta'),('Taufik'),('Umar'),('Vera'),('Wawan'),('Yoga'),('Zulfa'),('Agus'),('Dini');

-- Isi nama belakang (50 nama Indonesia)
INSERT INTO _nama_belakang (nama) VALUES 
('Santoso'),('Sari'),('Wijaya'),('Kusuma'),('Putra'),('Pratiwi'),('Hidayat'),('Nugroho'),('Lestari'),('Gunawan'),
('Ramadhan'),('Fauzi'),('Maulana'),('Hakim'),('Salim'),('Rachman'),('Siregar'),('Nasution'),('Harahap'),('Simanjuntak'),
('Sitorus'),('Manurung'),('Pasaribu'),('Sembiring'),('Tarigan'),('Ginting'),('Sinaga'),('Saragih'),('Purba'),('Situmorang'),
('Nainggolan'),('Sihombing'),('Hutabarat'),('Simatupang'),('Tambunan'),('Sianipar'),('Hasibuan'),('Lumban'),('Raja'),('Gultom'),
('Samosir'),('Sipayung'),('Pane'),('Silitonga'),('Napitupulu'),('Panjaitan'),('Tampubolon'),('Hutapea'),('Siburian'),('Pohan');

DELIMITER //

CREATE PROCEDURE generate_dummy_data()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE id_anggota_akhir INT;
    DECLARE id_buku_akhir INT;
    DECLARE id_peminjaman_akhir INT;
    DECLARE id_pengajuan_akhir INT;

    -- --------------------------------
    -- 1. TAMBAH ADMIN (total menjadi 5)
    -- --------------------------------
    SET i = (SELECT COUNT(*) FROM admin);
    WHILE i < 5 DO
        SET i = i + 1;
        INSERT INTO admin (username, password, nama_admin, created_at)
        VALUES (
            CONCAT('admin', i),
            '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
            CONCAT(
                (SELECT nama FROM _nama_depan ORDER BY RAND() LIMIT 1),
                ' ',
                (SELECT nama FROM _nama_belakang ORDER BY RAND() LIMIT 1)
            ),
            NOW() - INTERVAL FLOOR(RAND()*365) DAY
        );
    END WHILE;

    -- --------------------------------
    -- 2. TAMBAH ANGGOTA (total menjadi 153)
    -- --------------------------------
    SET i = (SELECT COUNT(*) FROM anggota);
    WHILE i < 153 DO
        SET i = i + 1;
        INSERT INTO anggota (nama, alamat, no_hp, email, created_at)
        VALUES (
            CONCAT(
                (SELECT nama FROM _nama_depan ORDER BY RAND() LIMIT 1),
                ' ',
                (SELECT nama FROM _nama_belakang ORDER BY RAND() LIMIT 1)
            ),
            CONCAT('Jl. ', (SELECT nama FROM _nama_depan ORDER BY RAND() LIMIT 1), ' No. ', FLOOR(RAND()*100)+1, ', Kota ', ELT(FLOOR(RAND()*5)+1, 'Jakarta','Bandung','Surabaya','Yogyakarta','Medan')),
            CONCAT('08', LPAD(FLOOR(RAND()*1000000000), 9, '0')),
            CONCAT('anggota', i, '@email.com'),
            NOW() - INTERVAL FLOOR(RAND()*1095) DAY
        );
    END WHILE;
    SET id_anggota_akhir = (SELECT MAX(id_anggota) FROM anggota);

    -- --------------------------------
    -- 3. TAMBAH BUKU (10 buku baru, total 18)
    -- --------------------------------
    INSERT INTO buku (judul, pengarang, kategori, tahun_terbit, stok, cover_buku, deskripsi, total_rating, jumlah_rating, created_at) VALUES
    ('Atomic Habits', 'James Clear', 'Pengembangan Diri', 2018, 5, NULL, 'Perubahan kecil yang membawa hasil besar.', 0, 0, NOW()),
    ('Sapiens', 'Yuval Noah Harari', 'Sejarah', 2015, 3, NULL, 'Sejarah singkat umat manusia.', 0, 0, NOW()),
    ('Laskar Pelangi', 'Andrea Hirata', 'Fiksi', 2005, 7, NULL, 'Kisah inspiratif tentang pendidikan di Belitung.', 0, 0, NOW()),
    ('Bumi Manusia', 'Pramoedya Ananta Toer', 'Sejarah', 1980, 4, NULL, 'Novel klasik tentang perjuangan bangsa.', 0, 0, NOW()),
    ('The Alchemist', 'Paulo Coelho', 'Fiksi', 1988, 6, NULL, 'Petualangan mencari harta karun dan makna hidup.', 0, 0, NOW()),
    ('Berpikir Cepat dan Lambat', 'Daniel Kahneman', 'Psikologi', 2011, 3, NULL, 'Sistem dua dalam berpikir.', 0, 0, NOW()),
    ('Harry Potter dan Batu Bertuah', 'J.K. Rowling', 'Fantasi', 1997, 8, NULL, 'Petualangan penyihir muda di Hogwarts.', 0, 0, NOW()),
    ('Dunia Sophie', 'Jostein Gaarder', 'Filsafat', 1991, 2, NULL, 'Pengantar filsafat melalui kisah misterius.', 0, 0, NOW()),
    ('Pulang', 'Tere Liye', 'Fiksi', 2015, 5, NULL, 'Kisah perjalanan pulang yang penuh makna.', 0, 0, NOW()),
    ('Rich Dad Poor Dad', 'Robert Kiyosaki', 'Keuangan', 1997, 4, NULL, 'Pelajaran finansial dari ayah kaya dan ayah miskin.', 0, 0, NOW());
    -- Total buku sekarang = 8 + 10 = 18
    SET id_buku_akhir = (SELECT MAX(id_buku) FROM buku);

    -- --------------------------------
    -- 4. TAMBAH PEMINJAMAN (total 205)
    -- --------------------------------
    SET i = (SELECT COUNT(*) FROM peminjaman);
    WHILE i < 205 DO
        SET i = i + 1;
        INSERT INTO peminjaman (id_anggota, id_buku, tanggal_pinjam, tanggal_kembali, status, created_at)
        VALUES (
            FLOOR(RAND() * id_anggota_akhir) + 1,
            FLOOR(RAND() * id_buku_akhir) + 1,
            CURDATE() - INTERVAL FLOOR(RAND()*365) DAY,
            CURDATE() - INTERVAL FLOOR(RAND()*30) DAY,
            ELT(FLOOR(RAND()*2)+1, 'dipinjam', 'dikembalikan'),
            NOW() - INTERVAL FLOOR(RAND()*365) DAY
        );
    END WHILE;
    SET id_peminjaman_akhir = (SELECT MAX(id_peminjaman) FROM peminjaman);

    -- --------------------------------
    -- 5. TAMBAH RATING_REVIEW (total 104)
    -- --------------------------------
    SET i = (SELECT COUNT(*) FROM rating_review);
    WHILE i < 104 DO
        SET i = i + 1;
        INSERT INTO rating_review (id_buku, nama_pengunjung, rating, review, created_at)
        VALUES (
            FLOOR(RAND() * id_buku_akhir) + 1,
            CONCAT(
                (SELECT nama FROM _nama_depan ORDER BY RAND() LIMIT 1),
                ' ',
                (SELECT nama FROM _nama_belakang ORDER BY RAND() LIMIT 1)
            ),
            FLOOR(RAND()*5) + 1,
            CONCAT('Review ke-', i, ' - ', (SELECT nama FROM _nama_depan ORDER BY RAND() LIMIT 1), ' mengatakan buku ini ', ELT(FLOOR(RAND()*3)+1, 'sangat bagus','menarik','membosankan')),
            NOW() - INTERVAL FLOOR(RAND()*365) DAY
        );
    END WHILE;

    -- Update total_rating di buku
    UPDATE buku b
    SET total_rating = (
        SELECT ROUND(AVG(rating), 1)
        FROM rating_review
        WHERE id_buku = b.id_buku
    ),
    jumlah_rating = (
        SELECT COUNT(*)
        FROM rating_review
        WHERE id_buku = b.id_buku
    )
    WHERE EXISTS (SELECT 1 FROM rating_review WHERE id_buku = b.id_buku);

    -- --------------------------------
    -- 6. TAMBAH LOG_AKTIVITAS (total 100)
    -- --------------------------------
    SET i = (SELECT COUNT(*) FROM log_aktivitas);
    WHILE i < 100 DO
        SET i = i + 1;
        INSERT INTO log_aktivitas (id_admin, aksi, tabel, data_id, detail, ip_address, created_at)
        VALUES (
            IF(RAND() > 0.5, FLOOR(RAND() * 5) + 1, NULL),
            ELT(FLOOR(RAND()*6)+1, 'login','logout','tambah','edit','hapus','lihat'),
            ELT(FLOOR(RAND()*5)+1, 'admin','anggota','buku','peminjaman','rating'),
            FLOOR(RAND() * 100) + 1,
            CONCAT('Detail log ke-', i),
            CONCAT(FLOOR(RAND()*255), '.', FLOOR(RAND()*255), '.', FLOOR(RAND()*255), '.', FLOOR(RAND()*255)),
            NOW() - INTERVAL FLOOR(RAND()*365) DAY
        );
    END WHILE;

    -- --------------------------------
    -- 7. TAMBAH PENGAJUAN_PEMINJAMAN (total 100)
    -- --------------------------------
    SET i = (SELECT COUNT(*) FROM pengajuan_peminjaman);
    WHILE i < 100 DO
        SET i = i + 1;
        INSERT INTO pengajuan_peminjaman (nama, alamat, no_hp, email, id_buku, tanggal_pinjam, tanggal_kembali, status, id_peminjaman, created_at, updated_at)
        VALUES (
            CONCAT(
                (SELECT nama FROM _nama_depan ORDER BY RAND() LIMIT 1),
                ' ',
                (SELECT nama FROM _nama_belakang ORDER BY RAND() LIMIT 1)
            ),
            CONCAT('Jl. Pengajuan No. ', i, ', Kota'),
            CONCAT('082', LPAD(FLOOR(RAND()*1000000000), 9, '0')),
            CONCAT('pemohon', i, '@email.com'),
            FLOOR(RAND() * id_buku_akhir) + 1,
            CURDATE() - INTERVAL FLOOR(RAND()*30) DAY,
            CURDATE() + INTERVAL FLOOR(RAND()*30) DAY,
            ELT(FLOOR(RAND()*4)+1, 'pending', 'paid', 'cancelled', 'expired'),
            IF(RAND() > 0.7, FLOOR(RAND() * id_peminjaman_akhir) + 1, NULL),
            NOW() - INTERVAL FLOOR(RAND()*60) DAY,
            NOW() - INTERVAL FLOOR(RAND()*30) DAY
        );
    END WHILE;
    SET id_pengajuan_akhir = (SELECT MAX(id_pengajuan) FROM pengajuan_peminjaman);

    -- --------------------------------
    -- 8. TAMBAH PEMBAYARAN_PENGAJUAN (total 80)
    -- --------------------------------
    SET i = (SELECT COUNT(*) FROM pembayaran_pengajuan);
    WHILE i < 80 DO
        SET i = i + 1;
        INSERT INTO pembayaran_pengajuan (id_pengajuan, id_peminjaman, reference, amount, currency, qr_url, qr_string, status, verified_at, raw_response, created_at, updated_at)
        VALUES (
            FLOOR(RAND() * id_pengajuan_akhir) + 1,
            IF(RAND() > 0.5, FLOOR(RAND() * id_peminjaman_akhir) + 1, NULL),
            CONCAT('REF-PP-', LPAD(i, 8, '0')),
            FLOOR(RAND() * 100000) + 1000,
            'IDR',
            CONCAT('http://qr.com/', i),
            CONCAT('QRSTRING', i),
            ELT(FLOOR(RAND()*5)+1, 'pending', 'verified', 'manual', 'failed', 'expired'),
            IF(RAND() > 0.5, NOW() - INTERVAL FLOOR(RAND()*30) DAY, NULL),
            JSON_OBJECT('response', CONCAT('raw_', i)),
            NOW() - INTERVAL FLOOR(RAND()*60) DAY,
            NOW() - INTERVAL FLOOR(RAND()*30) DAY
        );
    END WHILE;

    -- --------------------------------
    -- 9. TAMBAH PEMBAYARAN_PEMINJAMAN (total 100)
    -- --------------------------------
    SET i = (SELECT COUNT(*) FROM pembayaran_peminjaman);
    WHILE i < 100 DO
        SET i = i + 1;
        INSERT INTO pembayaran_peminjaman (id_peminjaman, reference, amount, currency, qr_url, qr_string, status, verified_at, raw_response, created_at, updated_at)
        VALUES (
            FLOOR(RAND() * id_peminjaman_akhir) + 1,
            CONCAT('REF-PM-', LPAD(i, 8, '0')),
            FLOOR(RAND() * 100000) + 1000,
            'IDR',
            CONCAT('http://qr-pm.com/', i),
            CONCAT('QRSTRING-PM', i),
            ELT(FLOOR(RAND()*5)+1, 'pending', 'verified', 'manual', 'failed', 'expired'),
            IF(RAND() > 0.5, NOW() - INTERVAL FLOOR(RAND()*30) DAY, NULL),
            JSON_OBJECT('response', CONCAT('raw_pm_', i)),
            NOW() - INTERVAL FLOOR(RAND()*60) DAY,
            NOW() - INTERVAL FLOOR(RAND()*30) DAY
        );
    END WHILE;

    -- --------------------------------
    -- 10. TAMBAH NOTIFIKASI_EMAIL (total 100)
    -- --------------------------------
    SET i = (SELECT COUNT(*) FROM notifikasi_email);
    WHILE i < 100 DO
        SET i = i + 1;
        INSERT INTO notifikasi_email (id_peminjaman, email, subject, body, status, created_at, sent_at)
        VALUES (
            IF(RAND() > 0.3, FLOOR(RAND() * id_peminjaman_akhir) + 1, NULL),
            CONCAT('notif', i, '@email.com'),
            CONCAT('Subject notifikasi ke-', i),
            CONCAT('Body notifikasi ke-', i, '. ', REPEAT('Pesan penting ', 3)),
            ELT(FLOOR(RAND()*3)+1, 'queued', 'sent', 'failed'),
            NOW() - INTERVAL FLOOR(RAND()*30) DAY,
            IF(RAND() > 0.3, NOW() - INTERVAL FLOOR(RAND()*30) DAY, NULL)
        );
    END WHILE;

    -- --------------------------------
    -- 11. TAMBAH REKOMENDASI_LOG (total 35)
    -- --------------------------------
    SET i = (SELECT COUNT(*) FROM rekomendasi_log);
    WHILE i < 35 DO
        SET i = i + 1;
        INSERT INTO rekomendasi_log (id_peminjaman, id_buku, score, source, created_at)
        VALUES (
            IF(RAND() > 0.4, FLOOR(RAND() * id_peminjaman_akhir) + 1, NULL),
            FLOOR(RAND() * id_buku_akhir) + 1,
            ROUND(RAND() * 10, 2),
            ELT(FLOOR(RAND()*3)+1, 'external_api', 'internal', 'collaborative'),
            NOW() - INTERVAL FLOOR(RAND()*90) DAY
        );
    END WHILE;

    -- Hapus temporary tables
    DROP TEMPORARY TABLE _nama_depan;
    DROP TEMPORARY TABLE _nama_belakang;

END //

DELIMITER ;

-- ============================================================
-- JALANKAN PROSEDUR UNTUK MENGHASILKAN DATA DUMMY
-- ============================================================
CALL generate_dummy_data();

-- (Opsional) Hapus prosedur setelah selesai
DROP PROCEDURE IF EXISTS generate_dummy_data;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- SELESAI — Total data = 1000 record
-- ============================================================