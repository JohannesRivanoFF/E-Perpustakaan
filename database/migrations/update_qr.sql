-- Ganti base_url dengan URL aplikasi Anda (tanpa trailing slash)
SET @base_url = 'http://localhost/E-Perpustakaan';

UPDATE pembayaran_pengajuan
SET 
    qr_string = CONCAT(@base_url, '/api/bayar_qr.php?reference=', reference),
    qr_url = CONCAT('https://api.qrserver.com/v1/create-qr-code/?size=260x260&margin=10&data=', 
                    CONCAT(@base_url, '/api/bayar_qr.php?reference=', reference))
WHERE 
    id_pembayaran > 0;  -- Update semua