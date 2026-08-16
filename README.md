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
```

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
