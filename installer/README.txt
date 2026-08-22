=====================================================
  ALFAMART POS - PANDUAN INSTALL LOKAL (OFFLINE)
=====================================================

SYARAT:
1. Node.js 18+  -> https://nodejs.org (pilih versi LTS)
2. XAMPP (untuk MySQL) -> https://www.apachefriends.org

CARA INSTALL (cukup SEKALI saja):
1. Pastikan XAMPP terpasang, buka XAMPP Control Panel,
   lalu klik START pada MySQL.
2. Buka folder "installer", klik dua kali: install.bat
   - Otomatis install dependencies
   - Otomatis membuat file .env
   - Otomatis membuat database + data contoh
3. Selesai!

CARA MENJALANKAN SETIAP HARI:
1. Nyalakan XAMPP -> START MySQL
2. Klik dua kali: start.bat
3. Browser akan terbuka otomatis di http://localhost:4000
4. Biarkan jendela hitam (server) tetap terbuka selama berjualan.

AKSES DARI HP / TABLET LAIN (via WiFi yang sama):
- Saat server jalan, lihat baris "Akses dari perangkat lain"
  di jendela server, contoh: http://192.168.1.5:4000
- Buka alamat itu dari browser HP yang terhubung WiFi yang sama.

PENGATURAN TOKO (nama, alamat, telepon, pajak):
- Edit file backend\.env pakai Notepad, lalu jalankan ulang start.bat
- Ganti nama toko di bagian STORE_NAME

GANTI PASSWORD MYSQL?
- Jika password MySQL bukan kosong, edit DB_PASSWORD di backend\.env
  lalu jalankan ulang install.bat

MULAI DARI AWAL (hapus semua data transaksi & produk):
- Jalankan di folder database:
    node setup-db.js --reset
- HATI-HATI: semua data akan hilang dan kembali ke data contoh.

CATATAN PENTING:
- Data tersimpan di database MySQL lokal komputer kasir.
- Lakukan backup rutin lewat phpMyAdmin -> Export.
- Aplikasi berjalan FULL OFFLINE, tidak butuh internet sama sekali.
=====================================================
