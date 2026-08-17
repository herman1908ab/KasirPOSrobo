// server.js — Alfamart POS Backend API (dengan upload gambar)
require('dotenv').config();
const express = require('express');
const cors    = require('cors');
const multer  = require('multer');
const path    = require('path');
const fs      = require('fs');
const db      = require('./db');

const app  = express();
const PORT = process.env.PORT || 4000;

// ── Folder uploads ──
const UPLOAD_DIR = path.join(__dirname, '../frontend/uploads');
if (!fs.existsSync(UPLOAD_DIR)) fs.mkdirSync(UPLOAD_DIR, { recursive: true });

// ── Seed gambar bawaan build ke uploads (supaya persist di volume) ──
const SEED_DIR = path.join(__dirname, '../seed-uploads');
if (fs.existsSync(SEED_DIR)) {
  try {
    let copied = 0;
    for (const f of fs.readdirSync(SEED_DIR)) {
      const dest = path.join(UPLOAD_DIR, f);
      if (!fs.existsSync(dest)) {
        fs.copyFileSync(path.join(SEED_DIR, f), dest);
        copied++;
      }
    }
    if (copied > 0) console.log(`🌱 Seed ${copied} gambar ke folder uploads`);
  } catch (e) {
    console.error('Gagal seed gambar:', e.message);
  }
}

// ── Konfigurasi Multer ──
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, UPLOAD_DIR),
  filename: (req, file, cb) => {
    const ext  = path.extname(file.originalname).toLowerCase();
    const name = `product_${Date.now()}_${Math.round(Math.random() * 1e6)}${ext}`;
    cb(null, name);
  }
});
const upload = multer({
  storage,
  limits: { fileSize: 2 * 1024 * 1024 }, // max 2MB
  fileFilter: (req, file, cb) => {
    const allowed = /jpeg|jpg|png|webp/;
    const okExt  = allowed.test(path.extname(file.originalname).toLowerCase());
    const okMime = allowed.test(file.mimetype);
    if (okExt && okMime) cb(null, true);
    else cb(new Error('Hanya file JPG, PNG, atau WEBP yang diizinkan'));
  }
});

app.set('trust proxy', true);
app.use(cors());
app.use(express.json());
app.use(express.static('../frontend'));   // sajikan frontend + /uploads/

// ──────────────────────────────────────────────────────────
// HELPER
// ──────────────────────────────────────────────────────────
function ok(res, data, message = 'OK') {
  res.json({ success: true, message, data });
}
function err(res, message, status = 400) {
  res.status(status).json({ success: false, message, data: null });
}
function generateInvoice() {
  const d   = new Date();
  const pad = n => String(n).padStart(2, '0');
  const date = `${d.getFullYear()}${pad(d.getMonth()+1)}${pad(d.getDate())}`;
  const rand = Math.floor(Math.random() * 9000) + 1000;
  return `INV-${date}-${rand}`;
}
// Hapus file lama jika ada
function deleteOldImage(imagePath) {
  if (!imagePath) return;
  const full = path.join(UPLOAD_DIR, path.basename(imagePath));
  if (fs.existsSync(full)) fs.unlinkSync(full);
}

// ══════════════════════════════════════════════════════════
// ROUTES: CATEGORIES
// ══════════════════════════════════════════════════════════
app.get('/api/categories', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM categories WHERE is_active = 1 ORDER BY sort_order, name');
    ok(res, rows);
  } catch (e) { err(res, e.message, 500); }
});

app.post('/api/categories', async (req, res) => {
  const { name, icon = '📦', sort_order = 0 } = req.body;
  if (!name) return err(res, 'Nama kategori wajib diisi');
  try {
    const [result] = await db.query(
      'INSERT INTO categories (name, icon, sort_order) VALUES (?, ?, ?)', [name, icon, sort_order]
    );
    const [rows] = await db.query('SELECT * FROM categories WHERE id = ?', [result.insertId]);
    ok(res, rows[0], 'Kategori berhasil ditambahkan');
  } catch (e) { err(res, e.message, 500); }
});

app.put('/api/categories/:id', async (req, res) => {
  const { name, icon, sort_order, is_active } = req.body;
  try {
    await db.query(
      'UPDATE categories SET name=IFNULL(?,name), icon=IFNULL(?,icon), sort_order=IFNULL(?,sort_order), is_active=IFNULL(?,is_active) WHERE id=?',
      [name, icon, sort_order, is_active, req.params.id]
    );
    const [rows] = await db.query('SELECT * FROM categories WHERE id = ?', [req.params.id]);
    ok(res, rows[0], 'Kategori berhasil diupdate');
  } catch (e) { err(res, e.message, 500); }
});

app.delete('/api/categories/:id', async (req, res) => {
  try {
    const [check] = await db.query(
      'SELECT COUNT(*) AS cnt FROM products WHERE category_id = ? AND is_active = 1', [req.params.id]
    );
    if (check[0].cnt > 0) return err(res, 'Tidak bisa hapus kategori yang masih memiliki produk aktif');
    await db.query('UPDATE categories SET is_active = 0 WHERE id = ?', [req.params.id]);
    ok(res, null, 'Kategori berhasil dihapus');
  } catch (e) { err(res, e.message, 500); }
});

// ══════════════════════════════════════════════════════════
// ROUTES: PRODUCTS
// ══════════════════════════════════════════════════════════

app.get('/api/products', async (req, res) => {
  try {
    const { category_id, search, low_stock, active = 1 } = req.query;
    let sql = `
      SELECT p.*, c.name AS category_name, c.icon AS category_icon
      FROM products p
      JOIN categories c ON c.id = p.category_id
      WHERE p.is_active = ?`;
    const params = [active];
    if (category_id) { sql += ' AND p.category_id = ?'; params.push(category_id); }
    if (search)      { sql += ' AND (p.name LIKE ? OR p.barcode LIKE ?)'; params.push(`%${search}%`, `%${search}%`); }
    if (low_stock)   { sql += ' AND p.stock <= p.min_stock'; }
    sql += ' ORDER BY c.sort_order, p.name';
    const [rows] = await db.query(sql, params);
    ok(res, rows);
  } catch (e) { err(res, e.message, 500); }
});

app.get('/api/products/:id', async (req, res) => {
  try {
    const [rows] = await db.query(
      `SELECT p.*, c.name AS category_name FROM products p
       JOIN categories c ON c.id = p.category_id WHERE p.id = ?`, [req.params.id]
    );
    if (!rows.length) return err(res, 'Produk tidak ditemukan', 404);
    ok(res, rows[0]);
  } catch (e) { err(res, e.message, 500); }
});

app.get('/api/products/barcode/:code', async (req, res) => {
  try {
    const [rows] = await db.query(
      `SELECT p.*, c.name AS category_name FROM products p
       JOIN categories c ON c.id = p.category_id
       WHERE p.barcode = ? AND p.is_active = 1`, [req.params.code]
    );
    if (!rows.length) return err(res, 'Produk tidak ditemukan', 404);
    ok(res, rows[0]);
  } catch (e) { err(res, e.message, 500); }
});

// POST /api/products — tambah produk (dengan optional upload gambar)
app.post('/api/products', upload.single('image'), async (req, res) => {
  const {
    category_id, barcode, name, description,
    price, cost_price = 0, stock = 0, min_stock = 5,
    unit = 'pcs', emoji = '📦', promo_label
  } = req.body;

  if (!category_id || !name || !price)
    return err(res, 'category_id, name, dan price wajib diisi');

  // Jika ada file gambar yang diupload, simpan path-nya
  const image_url = req.file ? `/uploads/${req.file.filename}` : null;

  try {
    const [result] = await db.query(
      `INSERT INTO products
        (category_id, barcode, name, description, price, cost_price,
         stock, min_stock, unit, emoji, promo_label, image_url)
       VALUES (?,?,?,?,?,?,?,?,?,?,?,?)`,
      [category_id, barcode||null, name, description||null, price, cost_price,
       stock, min_stock, unit, emoji, promo_label||null, image_url]
    );
    if (stock > 0) {
      await db.query(
        'INSERT INTO stock_logs (product_id, change_type, qty_before, qty_change, qty_after, reference) VALUES (?,?,?,?,?,?)',
        [result.insertId, 'initial', 0, stock, stock, 'Stok awal']
      );
    }
    const [rows] = await db.query('SELECT * FROM products WHERE id = ?', [result.insertId]);
    ok(res, rows[0], 'Produk berhasil ditambahkan');
  } catch (e) {
    // Hapus file yang sudah terupload jika insert gagal
    if (req.file) deleteOldImage(image_url);
    if (e.code === 'ER_DUP_ENTRY') return err(res, 'Barcode sudah digunakan');
    err(res, e.message, 500);
  }
});

// PUT /api/products/:id — update produk (dengan optional ganti gambar)
app.put('/api/products/:id', upload.single('image'), async (req, res) => {
  const {
    category_id, barcode, name, description,
    price, cost_price, min_stock, unit,
    emoji, promo_label, is_active, remove_image
  } = req.body;

  try {
    // Ambil data lama untuk tahu apakah ada gambar lama
    const [existing] = await db.query('SELECT image_url FROM products WHERE id = ?', [req.params.id]);
    if (!existing.length) return err(res, 'Produk tidak ditemukan', 404);
    const oldImage = existing[0].image_url;

    let new_image_url = oldImage; // default tetap gambar lama

    if (req.file) {
      // Ada gambar baru → hapus gambar lama, pakai yang baru
      deleteOldImage(oldImage);
      new_image_url = `/uploads/${req.file.filename}`;
    } else if (remove_image === 'true' || remove_image === true) {
      // Hapus gambar tanpa ganti
      deleteOldImage(oldImage);
      new_image_url = null;
    }

    await db.query(
      `UPDATE products SET
        category_id   = IFNULL(?, category_id),
        barcode       = IFNULL(?, barcode),
        name          = IFNULL(?, name),
        description   = IFNULL(?, description),
        price         = IFNULL(?, price),
        cost_price    = IFNULL(?, cost_price),
        min_stock     = IFNULL(?, min_stock),
        unit          = IFNULL(?, unit),
        emoji         = IFNULL(?, emoji),
        promo_label   = ?,
        image_url     = ?,
        is_active     = IFNULL(?, is_active)
       WHERE id = ?`,
      [category_id, barcode, name, description, price, cost_price,
       min_stock, unit, emoji, promo_label||null, new_image_url, is_active, req.params.id]
    );
    const [rows] = await db.query('SELECT * FROM products WHERE id = ?', [req.params.id]);
    ok(res, rows[0], 'Produk berhasil diupdate');
  } catch (e) {
    if (req.file) deleteOldImage(`/uploads/${req.file.filename}`);
    if (e.code === 'ER_DUP_ENTRY') return err(res, 'Barcode sudah digunakan');
    err(res, e.message, 500);
  }
});

app.delete('/api/products/:id', async (req, res) => {
  try {
    // Ambil gambar sebelum hapus (soft delete tidak hapus file, tapi bisa dikustom)
    await db.query('UPDATE products SET is_active = 0 WHERE id = ?', [req.params.id]);
    ok(res, null, 'Produk berhasil dihapus');
  } catch (e) { err(res, e.message, 500); }
});

app.patch('/api/products/:id/restock', async (req, res) => {
  const { qty, cashier_id = 1, notes = 'Restock' } = req.body;
  if (!qty || qty <= 0) return err(res, 'Jumlah qty harus lebih dari 0');
  try {
    const [rows] = await db.query('SELECT stock FROM products WHERE id = ?', [req.params.id]);
    if (!rows.length) return err(res, 'Produk tidak ditemukan', 404);
    const before = rows[0].stock;
    await db.query('UPDATE products SET stock = stock + ? WHERE id = ?', [qty, req.params.id]);
    await db.query(
      'INSERT INTO stock_logs (product_id, change_type, qty_before, qty_change, qty_after, reference, cashier_id) VALUES (?,?,?,?,?,?,?)',
      [req.params.id, 'restock', before, qty, before + qty, notes, cashier_id]
    );
    ok(res, { stock: before + qty }, `Stok berhasil ditambah ${qty}`);
  } catch (e) { err(res, e.message, 500); }
});

// ══════════════════════════════════════════════════════════
// ROUTES: TRANSACTIONS
// ══════════════════════════════════════════════════════════
app.post('/api/transactions', async (req, res) => {
  const { cashier_id = 1, items, payment_method = 'cash', paid_amount, notes } = req.body;
  if (!items || !items.length) return err(res, 'Items tidak boleh kosong');
  try {
    const ids = items.map(i => i.product_id);
    const [prods] = await db.query(
      'SELECT id, name, price, stock FROM products WHERE id IN (?) AND is_active = 1', [ids]
    );
    const productMap = {};
    prods.forEach(p => productMap[p.id] = p);

    let subtotal = 0;
    for (const item of items) {
      const p = productMap[item.product_id];
      if (!p) return err(res, `Produk ID ${item.product_id} tidak ditemukan`);
      if (p.stock < item.quantity) return err(res, `Stok ${p.name} tidak mencukupi (tersisa: ${p.stock})`);
      subtotal += p.price * item.quantity;
    }

    const taxRate = parseFloat(process.env.TAX_RATE || 0.11);
    const tax     = Math.round(subtotal * taxRate);
    const total   = subtotal + tax;
    const paid    = parseFloat(paid_amount) || total;
    const change  = paid - total;
    const invoice = generateInvoice();

    if (paid < total) return err(res, 'Jumlah bayar tidak mencukupi');

    const conn = await db.getConnection();
    await conn.beginTransaction();
    try {
      const [trxResult] = await conn.query(
        `INSERT INTO transactions
          (invoice_number, cashier_id, subtotal, tax_amount, total_amount,
           paid_amount, change_amount, payment_method, notes)
         VALUES (?,?,?,?,?,?,?,?,?)`,
        [invoice, cashier_id, subtotal, tax, total, paid, change, payment_method, notes||null]
      );
      const trxId = trxResult.insertId;
      for (const item of items) {
        const p = productMap[item.product_id];
        await conn.query(
          'INSERT INTO transaction_items (transaction_id, product_id, product_name, product_price, quantity, subtotal) VALUES (?,?,?,?,?,?)',
          [trxId, p.id, p.name, p.price, item.quantity, p.price * item.quantity]
        );
        const before = p.stock;
        await conn.query('UPDATE products SET stock = stock - ? WHERE id = ?', [item.quantity, p.id]);
        await conn.query(
          'INSERT INTO stock_logs (product_id, change_type, qty_before, qty_change, qty_after, reference, cashier_id) VALUES (?,?,?,?,?,?,?)',
          [p.id, 'sale', before, -item.quantity, before - item.quantity, invoice, cashier_id]
        );
      }
      await conn.commit();
      conn.release();
      const [trxRows]  = await db.query(
        `SELECT t.*, c.name AS cashier_name FROM transactions t
         JOIN cashiers c ON c.id = t.cashier_id WHERE t.id = ?`, [trxId]
      );
      const [itemRows] = await db.query(
        `SELECT ti.*, p.emoji, p.image_url FROM transaction_items ti
         LEFT JOIN products p ON p.id = ti.product_id
         WHERE ti.transaction_id = ?`, [trxId]
      );
      ok(res, { transaction: trxRows[0], items: itemRows }, 'Transaksi berhasil');
    } catch (e) {
      await conn.rollback();
      conn.release();
      throw e;
    }
  } catch (e) { err(res, e.message, 500); }
});

app.get('/api/transactions', async (req, res) => {
  try {
    const { date_from, date_to, cashier_id, payment_method, page = 1, limit = 20 } = req.query;
    let sql = `
      SELECT t.*, c.name AS cashier_name, COUNT(ti.id) AS item_count
      FROM transactions t
      JOIN cashiers c ON c.id = t.cashier_id
      LEFT JOIN transaction_items ti ON ti.transaction_id = t.id
      WHERE t.payment_status = 'paid'`;
    const params = [];
    if (date_from)      { sql += ' AND DATE(t.created_at) >= ?'; params.push(date_from); }
    if (date_to)        { sql += ' AND DATE(t.created_at) <= ?'; params.push(date_to); }
    if (cashier_id)     { sql += ' AND t.cashier_id = ?'; params.push(cashier_id); }
    if (payment_method) { sql += ' AND t.payment_method = ?'; params.push(payment_method); }
    sql += ' GROUP BY t.id ORDER BY t.created_at DESC';
    const [countRows] = await db.query(`SELECT COUNT(*) AS total FROM (${sql}) AS sub`, params);
    const total  = countRows[0].total;
    const offset = (parseInt(page) - 1) * parseInt(limit);
    sql += ` LIMIT ? OFFSET ?`;
    params.push(parseInt(limit), offset);
    const [rows] = await db.query(sql, params);
    ok(res, { transactions: rows, pagination: { total, page: parseInt(page), limit: parseInt(limit), pages: Math.ceil(total/limit) } });
  } catch (e) { err(res, e.message, 500); }
});

app.get('/api/transactions/:id', async (req, res) => {
  try {
    const [trxRows] = await db.query(
      `SELECT t.*, c.name AS cashier_name FROM transactions t
       JOIN cashiers c ON c.id = t.cashier_id WHERE t.id = ?`, [req.params.id]
    );
    if (!trxRows.length) return err(res, 'Transaksi tidak ditemukan', 404);
    const [itemRows] = await db.query(
      `SELECT ti.*, p.emoji, p.image_url FROM transaction_items ti
       LEFT JOIN products p ON p.id = ti.product_id
       WHERE ti.transaction_id = ?`, [req.params.id]
    );
    ok(res, { transaction: trxRows[0], items: itemRows });
  } catch (e) { err(res, e.message, 500); }
});

// ══════════════════════════════════════════════════════════
// ROUTES: REPORTS
// ══════════════════════════════════════════════════════════
app.get('/api/reports/summary', async (req, res) => {
  const { date, date_from, date_to, limit = 5 } = req.query;
  try {
    // Bangun kondisi tanggal: pakai `date` (1 hari) atau rentang date_from/date_to
    const tParams = [];
    let tCond = '1=1';
    if (date)           { tCond = 'DATE(created_at) = ?';           tParams.push(date); }
    else if (date_from || date_to) {
      const parts = [];
      if (date_from) { parts.push('DATE(created_at) >= ?'); tParams.push(date_from); }
      if (date_to)   { parts.push('DATE(created_at) <= ?'); tParams.push(date_to); }
      tCond = parts.join(' AND ');
    }

    const [summary] = await db.query(`
      SELECT
        COUNT(*) AS total_transactions,
        IFNULL(SUM(total_amount),0) AS total_revenue,
        IFNULL(AVG(total_amount),0) AS avg_transaction,
        IFNULL(SUM(CASE WHEN payment_method='cash'  THEN total_amount ELSE 0 END),0) AS cash_revenue,
        IFNULL(SUM(CASE WHEN payment_method='debit' THEN total_amount ELSE 0 END),0) AS debit_revenue,
        IFNULL(SUM(CASE WHEN payment_method='qris'  THEN total_amount ELSE 0 END),0) AS qris_revenue
      FROM transactions WHERE ${tCond} AND payment_status = 'paid'`, tParams
    );

    const tpParams = [];
    let tpCond = '1=1';
    if (date)           { tpCond = 'DATE(t.created_at) = ?';           tpParams.push(date); }
    else if (date_from || date_to) {
      const parts = [];
      if (date_from) { parts.push('DATE(t.created_at) >= ?'); tpParams.push(date_from); }
      if (date_to)   { parts.push('DATE(t.created_at) <= ?'); tpParams.push(date_to); }
      tpCond = parts.join(' AND ');
    }
    tpParams.push(parseInt(limit) || 5);

    const [topProducts] = await db.query(`
      SELECT ti.product_name, ti.product_id, p.emoji, p.image_url,
             SUM(ti.quantity) AS total_qty, SUM(ti.subtotal) AS total_revenue
      FROM transaction_items ti
      JOIN transactions t ON t.id = ti.transaction_id
      LEFT JOIN products p ON p.id = ti.product_id
      WHERE ${tpCond} AND t.payment_status = 'paid'
      GROUP BY ti.product_id, ti.product_name, p.emoji, p.image_url
      ORDER BY total_qty DESC LIMIT ?`, tpParams
    );
    const [lowStock] = await db.query(
      'SELECT id, name, emoji, image_url, stock, min_stock FROM products WHERE stock <= min_stock AND is_active = 1 ORDER BY stock ASC'
    );
    ok(res, { summary: summary[0], top_products: topProducts, low_stock: lowStock });
  } catch (e) { err(res, e.message, 500); }
});

app.get('/api/reports/daily', async (req, res) => {
  const { date_from, date_to } = req.query;
  try {
    const params = [];
    let where = 'created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)';
    const parts = [];
    if (date_from) { parts.push('DATE(created_at) >= ?'); params.push(date_from); }
    if (date_to)   { parts.push('DATE(created_at) <= ?'); params.push(date_to); }
    if (parts.length) where = parts.join(' AND ');
    const [rows] = await db.query(`
      SELECT DATE(created_at) AS date, COUNT(*) AS transactions, SUM(total_amount) AS revenue
      FROM transactions
      WHERE ${where} AND payment_status = 'paid'
      GROUP BY DATE(created_at) ORDER BY date ASC`, params
    );
    ok(res, rows);
  } catch (e) { err(res, e.message, 500); }
});

// ══════════════════════════════════════════════════════════
// ROUTES: STOCK LOGS & CONFIG
// ══════════════════════════════════════════════════════════
app.get('/api/stock-logs/:product_id', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT sl.*, c.name AS cashier_name FROM stock_logs sl
      LEFT JOIN cashiers c ON c.id = sl.cashier_id
      WHERE sl.product_id = ? ORDER BY sl.created_at DESC LIMIT 50`, [req.params.product_id]
    );
    ok(res, rows);
  } catch (e) { err(res, e.message, 500); }
});

app.get('/api/config', (req, res) => {
  ok(res, {
    store_name:    process.env.STORE_NAME    || 'Alfamart',
    store_address: process.env.STORE_ADDRESS || '',
    store_phone:   process.env.STORE_PHONE   || '',
    tax_rate:      parseFloat(process.env.TAX_RATE || 0.11),
  });
});

// ══════════════════════════════════════════════════════════
// ROUTES: VISITORS
// ══════════════════════════════════════════════════════════

// Auto-buat tabel visitor_logs (aman jika belum ada)
db.query(`CREATE TABLE IF NOT EXISTS visitor_logs (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  ip_address VARCHAR(64) NOT NULL DEFAULT '',
  user_agent VARCHAR(255) NOT NULL DEFAULT '',
  visited_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_ip (ip_address),
  INDEX idx_visited (visited_at)
) ENGINE=InnoDB`)
  .then(() => console.log('👁 Tabel visitor_logs siap'))
  .catch(e => console.error('⚠️ Gagal buat tabel visitor_logs:', e.message));

// Catat kunjungan baru (per akses halaman index)
app.post('/api/visitors', async (req, res) => {
  try {
    const ip  = req.ip || req.socket.remoteAddress || 'unknown';
    const ua  = (req.headers['user-agent'] || '').slice(0, 255);
    await db.query('INSERT INTO visitor_logs (ip_address, user_agent) VALUES (?,?)', [ip, ua]);
    const [v] = await db.query('SELECT COUNT(*) AS total_visits FROM visitor_logs');
    const [u] = await db.query('SELECT COUNT(DISTINCT ip_address) AS unique_visitors FROM visitor_logs');
    ok(res, { total_visits: v[0].total_visits, unique_visitors: u[0].unique_visitors }, 'Kunjungan dicatat');
  } catch (e) { err(res, e.message, 500); }
});

// Ambil jumlah kunjungan
app.get('/api/visitors/count', async (req, res) => {
  try {
    const [v] = await db.query('SELECT COUNT(*) AS total_visits FROM visitor_logs');
    const [u] = await db.query('SELECT COUNT(DISTINCT ip_address) AS unique_visitors FROM visitor_logs');
    ok(res, { total_visits: v[0].total_visits, unique_visitors: u[0].unique_visitors });
  } catch (e) { err(res, e.message, 500); }
});

// ── Error handler multer ──
app.use((error, req, res, next) => {
  if (error instanceof multer.MulterError) {
    if (error.code === 'LIMIT_FILE_SIZE') return err(res, 'Ukuran file terlalu besar (maks 2MB)', 400);
    return err(res, error.message, 400);
  }
  if (error && error.message) return err(res, error.message, 400);
  console.error('Unhandled error:', error);
  res.status(500).json({ success: false, message: 'Internal server error' });
});

app.use((req, res) => res.status(404).json({ success: false, message: 'Endpoint tidak ditemukan' }));

// Start server
app.listen(PORT, () => {
  console.log(`\n🚀 Alfamart POS Server berjalan di http://localhost:${PORT}`);
  console.log(`🌐 Buka browser  : http://localhost:${PORT}`);
  console.log(`📊 Database      : ${process.env.DB_NAME}`);
  console.log(`🏪 Toko          : ${process.env.STORE_NAME}`);
  console.log(`📁 Upload folder : ${UPLOAD_DIR}\n`);
});
