# 🏪 Alfamart POS — Sistem Kasir Digital dengan MySQL

Aplikasi kasir lengkap berbasis Node.js + Express + MySQL dengan fitur Master Produk, Transaksi, dan Riwayat.

---

## 📁 Struktur Proyek

```
alfamart-pos/
├── backend/
│   ├── server.js          ← API server (Express)
│   ├── db.js              ← Koneksi MySQL (connection pool)
│   ├── package.json
│   └── .env.example       ← Template konfigurasi
├── frontend/
│   └── index.html         ← Aplikasi kasir (buka di browser)
└── database/
    └── schema.sql         ← Schema + seed data MySQL
```

---

## ⚙️ Persyaratan Sistem

- **Node.js** v18+ → https://nodejs.org
- **MySQL** 8.0+ → https://dev.mysql.com/downloads/
- Browser modern (Chrome, Edge, Firefox)

---

## 🚀 Cara Instalasi & Menjalankan

### 1. Siapkan Database MySQL

```sql
-- Login ke MySQL
mysql -u root -p

-- Jalankan schema (buat database + tabel + seed data)
source /path/to/alfamart-pos/database/schema.sql
```

Atau via MySQL Workbench / phpMyAdmin:
- Buka file `database/schema.sql`
- Jalankan semua query

### 2. Konfigurasi Backend

```bash
cd alfamart-pos/backend

# Salin file konfigurasi
cp .env.example .env

# Edit .env sesuai konfigurasi MySQL Anda
nano .env
```

Isi file `.env`:
```env
PORT=3000
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=password_mysql_anda
DB_NAME=alfamart_pos

STORE_NAME=Alfamart Sudirman 01
STORE_ADDRESS=Jl. Jend. Sudirman No.1, Jakarta Pusat
STORE_PHONE=(021) 555-0101
TAX_RATE=0.11

# Opsional: kirim ringkasan struk setelah pembayaran berhasil
TELEGRAM_BOT_TOKEN=token_dari_BotFather
# Kosongkan untuk memasukkan Chat ID pelanggan saat pembayaran
TELEGRAM_DEFAULT_CHAT_ID=
```

### Notifikasi struk via Telegram

1. Buat bot melalui Telegram `@BotFather`, lalu salin token-nya ke `TELEGRAM_BOT_TOKEN` pada `backend/.env`.
2. Pelanggan perlu membuka bot tersebut dan mengirim `/start` sekali. Telegram tidak mengizinkan bot menghubungi pengguna yang belum pernah memulai percakapan.
3. Saat pembayaran, masukkan Chat ID pelanggan pada kolom **Kirim struk Telegram**. Chat ID dapat diperoleh dari bot internal Anda atau bot pemeriksa ID yang tepercaya.

Jika `TELEGRAM_DEFAULT_CHAT_ID` diisi, struk akan dikirim ke ID tersebut ketika kolom pelanggan dibiarkan kosong. Pengiriman notifikasi tidak membatalkan atau mengubah transaksi apabila Telegram sedang gagal dihubungi.

### Notifikasi struk via WhatsApp

Integrasi ini memakai **WhatsApp Cloud API dari Meta**. Tambahkan kredensial berikut ke `backend/.env`:

```env
WHATSAPP_ACCESS_TOKEN=token_akses_permanen_meta
WHATSAPP_PHONE_NUMBER_ID=id_nomor_pengirim_dari_meta
WHATSAPP_API_VERSION=v23.0
WHATSAPP_DEFAULT_TO=
# Opsional, tetapi diperlukan untuk mengirim di luar jendela 24 jam
WHATSAPP_TEMPLATE_NAME=
WHATSAPP_TEMPLATE_LANGUAGE=id
```

Masukkan nomor WhatsApp pelanggan saat pembayaran dalam format internasional tanpa `+`, contohnya `628123456789`. Integrasi memanggil endpoint WhatsApp Cloud API resmi untuk pesan teks dengan `Phone Number ID` dan Bearer token. [Referensi koleksi resmi Meta](https://www.postman.com/meta/whatsapp-business-platform/request/8gvd47s/send-text-message).

Pengiriman teks bebas hanya dapat dilakukan dalam jendela percakapan WhatsApp (umumnya 24 jam setelah pelanggan menghubungi bisnis). Agar struk dikirim pada setiap pembayaran, buat dan setujui **utility template** Meta dengan tepat satu placeholder body `{{1}}`—misalnya: `Terima kasih. Berikut ringkasan struk Anda:\n{{1}}`—lalu isi `WHATSAPP_TEMPLATE_NAME` dan `WHATSAPP_TEMPLATE_LANGUAGE`. Di luar jendela tersebut backend otomatis menggunakan template ini; transaksi tetap tersimpan bila pengiriman ditolak.

### 3. Install Dependencies & Jalankan Server

```bash
cd alfamart-pos/backend

# Install package
npm install

# Jalankan server
npm start

# Atau mode development (auto-restart)
npm run dev
```

Output yang muncul jika berhasil:
```
✅ MySQL terhubung: alfamart_pos
🚀 Alfamart POS Server berjalan di http://localhost:3000
📊 Database : alfamart_pos
🏪 Toko     : Alfamart Sudirman 01
```

### 4. Buka Aplikasi

Buka browser dan akses:
```
http://localhost:3000
```

---

## 🗄️ Struktur Database

| Tabel | Fungsi |
|-------|--------|
| `categories` | Master kategori produk |
| `products` | Master produk/barang (harga, stok, dll) |
| `cashiers` | Data kasir & login |
| `transactions` | Header transaksi |
| `transaction_items` | Detail item per transaksi |
| `stock_logs` | Log riwayat perubahan stok |

---

## 📡 API Endpoints

### Produk
| Method | Endpoint | Fungsi |
|--------|----------|--------|
| GET | `/api/products` | Daftar produk (filter: category_id, search, low_stock) |
| GET | `/api/products/:id` | Detail produk |
| GET | `/api/products/barcode/:code` | Cari by barcode |
| POST | `/api/products` | Tambah produk baru |
| PUT | `/api/products/:id` | Edit produk |
| DELETE | `/api/products/:id` | Hapus produk (soft delete) |
| PATCH | `/api/products/:id/restock` | Tambah stok |

### Transaksi
| Method | Endpoint | Fungsi |
|--------|----------|--------|
| POST | `/api/transactions` | Buat transaksi baru |
| GET | `/api/transactions` | Riwayat transaksi (filter: date_from, date_to, payment_method) |
| GET | `/api/transactions/:id` | Detail transaksi + items |

### Laporan
| Method | Endpoint | Fungsi |
|--------|----------|--------|
| GET | `/api/reports/summary?date=YYYY-MM-DD` | Ringkasan harian |
| GET | `/api/reports/daily` | Tren 7 hari terakhir |

### Lainnya
| Method | Endpoint | Fungsi |
|--------|----------|--------|
| GET | `/api/categories` | Daftar kategori |
| GET | `/api/config` | Konfigurasi toko |
| GET | `/api/stock-logs/:product_id` | Log stok produk |

---

## ✨ Fitur Utama

### 🏪 Kasir
- Tampilan produk dengan grid, filter kategori, pencarian
- Keranjang belanja dengan qty control
- 3 metode pembayaran: Tunai, Debit, QRIS
- Numpad + nominal cepat untuk kasir tunai
- Hitung kembalian otomatis
- Preview & cetak struk setelah transaksi
- Stok otomatis berkurang saat transaksi berhasil

### 📦 Master Produk
- CRUD produk lengkap (tambah, edit, hapus)
- Field: nama, barcode, kategori, harga jual, harga modal, stok, unit, emoji, promo
- Tampil margin/profit per produk
- Indicator stok minim (orange) dan habis (merah)
- Fitur restock dengan logging

### 📋 Riwayat Transaksi
- Filter by rentang tanggal
- Statistik: total transaksi, pendapatan, rata-rata
- Lihat detail & cetak ulang struk

---

## 🔒 Keamanan

- Harga dihitung ulang di **server** (anti-manipulasi dari client)
- Pengecekan stok dilakukan dalam **MySQL transaction** (atomic)
- Stok tidak akan minus walau ada request bersamaan
- Semua perubahan stok dicatat di `stock_logs`

---

## 🛠️ Pengembangan Lanjutan

Fitur yang bisa ditambahkan:
- [ ] Login/autentikasi kasir dengan JWT
- [ ] Manajemen kategori (CRUD)
- [ ] Laporan grafik (Chart.js)
- [ ] Export laporan ke Excel/PDF
- [ ] Multi-toko / multi-terminal
- [ ] Diskon & voucher
- [ ] Integrasi printer thermal (ESC/POS)
- [ ] Backup database otomatis
