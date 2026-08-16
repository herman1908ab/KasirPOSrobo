-- ============================================================
-- ALFAMART POS - DATABASE SCHEMA
-- MySQL 8.0+
-- ============================================================

CREATE DATABASE IF NOT EXISTS alfamart_pos
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE alfamart_pos;

-- ============================================================
-- TABEL: categories (Kategori Produk)
-- ============================================================
CREATE TABLE IF NOT EXISTS categories (
  id        INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name      VARCHAR(100) NOT NULL,
  icon      VARCHAR(10)  NOT NULL DEFAULT '📦',
  is_active TINYINT(1)   NOT NULL DEFAULT 1,
  sort_order INT          NOT NULL DEFAULT 0,
  created_at DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- TABEL: products (Master Produk/Barang)
-- ============================================================
CREATE TABLE IF NOT EXISTS products (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  category_id INT UNSIGNED NOT NULL,
  barcode     VARCHAR(50)  UNIQUE,
  name        VARCHAR(200) NOT NULL,
  description TEXT,
  price       DECIMAL(12,2) NOT NULL DEFAULT 0,
  cost_price  DECIMAL(12,2) NOT NULL DEFAULT 0,   -- harga modal
  stock       INT          NOT NULL DEFAULT 0,
  min_stock   INT          NOT NULL DEFAULT 5,     -- minimum stok (untuk alert)
  unit        VARCHAR(20)  NOT NULL DEFAULT 'pcs',
  emoji       VARCHAR(10)  NOT NULL DEFAULT '📦',
  image_url   VARCHAR(300) DEFAULT NULL,              -- path gambar produk (/uploads/namafile.jpg)
  promo_label VARCHAR(20)  DEFAULT NULL,
  is_active   TINYINT(1)   NOT NULL DEFAULT 1,
  created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================
-- TABEL: cashiers (Data Kasir)
-- ============================================================
CREATE TABLE IF NOT EXISTS cashiers (
  id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name       VARCHAR(100) NOT NULL,
  username   VARCHAR(50)  NOT NULL UNIQUE,
  pin        VARCHAR(6)   NOT NULL,               -- PIN 6 digit
  role       ENUM('admin','cashier') NOT NULL DEFAULT 'cashier',
  is_active  TINYINT(1)   NOT NULL DEFAULT 1,
  created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- TABEL: transactions (Header Transaksi)
-- ============================================================
CREATE TABLE IF NOT EXISTS transactions (
  id             INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  invoice_number VARCHAR(30)   NOT NULL UNIQUE,
  cashier_id     INT UNSIGNED  NOT NULL,
  subtotal       DECIMAL(12,2) NOT NULL DEFAULT 0,
  tax_amount     DECIMAL(12,2) NOT NULL DEFAULT 0,
  discount_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
  total_amount   DECIMAL(12,2) NOT NULL DEFAULT 0,
  paid_amount    DECIMAL(12,2) NOT NULL DEFAULT 0,
  change_amount  DECIMAL(12,2) NOT NULL DEFAULT 0,
  payment_method ENUM('cash','debit','qris') NOT NULL DEFAULT 'cash',
  payment_status ENUM('paid','pending','cancelled') NOT NULL DEFAULT 'paid',
  notes          TEXT          DEFAULT NULL,
  created_at     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (cashier_id) REFERENCES cashiers(id) ON DELETE RESTRICT,
  INDEX idx_invoice     (invoice_number),
  INDEX idx_created_at  (created_at),
  INDEX idx_cashier     (cashier_id),
  INDEX idx_payment_method (payment_method)
) ENGINE=InnoDB;

-- ============================================================
-- TABEL: transaction_items (Detail Item Transaksi)
-- ============================================================
CREATE TABLE IF NOT EXISTS transaction_items (
  id             INT UNSIGNED  AUTO_INCREMENT PRIMARY KEY,
  transaction_id INT UNSIGNED  NOT NULL,
  product_id     INT UNSIGNED  NOT NULL,
  product_name   VARCHAR(200)  NOT NULL,          -- snapshot nama saat transaksi
  product_price  DECIMAL(12,2) NOT NULL,          -- snapshot harga saat transaksi
  quantity       INT           NOT NULL DEFAULT 1,
  subtotal       DECIMAL(12,2) NOT NULL DEFAULT 0,
  FOREIGN KEY (transaction_id) REFERENCES transactions(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id)     REFERENCES products(id)     ON DELETE RESTRICT,
  INDEX idx_transaction (transaction_id),
  INDEX idx_product     (product_id)
) ENGINE=InnoDB;

-- ============================================================
-- TABEL: stock_logs (Log Perubahan Stok)
-- ============================================================
CREATE TABLE IF NOT EXISTS stock_logs (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  product_id  INT UNSIGNED NOT NULL,
  change_type ENUM('sale','restock','adjustment','initial') NOT NULL,
  qty_before  INT NOT NULL,
  qty_change  INT NOT NULL,
  qty_after   INT NOT NULL,
  reference   VARCHAR(50) DEFAULT NULL,           -- invoice number / keterangan
  cashier_id  INT UNSIGNED DEFAULT NULL,
  created_at  DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id)  REFERENCES products(id)  ON DELETE CASCADE,
  FOREIGN KEY (cashier_id)  REFERENCES cashiers(id)  ON DELETE SET NULL,
  INDEX idx_product   (product_id),
  INDEX idx_created   (created_at)
) ENGINE=InnoDB;

-- ============================================================
-- STORED PROCEDURE: create_transaction
-- Membuat transaksi baru + update stok secara atomic
-- ============================================================
DELIMITER $$
CREATE PROCEDURE create_transaction(
  IN p_invoice      VARCHAR(30),
  IN p_cashier_id   INT UNSIGNED,
  IN p_subtotal     DECIMAL(12,2),
  IN p_tax          DECIMAL(12,2),
  IN p_discount     DECIMAL(12,2),
  IN p_total        DECIMAL(12,2),
  IN p_paid         DECIMAL(12,2),
  IN p_change       DECIMAL(12,2),
  IN p_method       VARCHAR(10),
  IN p_items_json   JSON,
  OUT p_trx_id      INT UNSIGNED,
  OUT p_error       VARCHAR(200)
)
BEGIN
  DECLARE v_product_id   INT UNSIGNED;
  DECLARE v_product_name VARCHAR(200);
  DECLARE v_price        DECIMAL(12,2);
  DECLARE v_qty          INT;
  DECLARE v_stock        INT;
  DECLARE v_i            INT DEFAULT 0;
  DECLARE v_count        INT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_trx_id = 0;
    SET p_error  = 'Database error occurred';
  END;

  SET p_error = '';
  SET v_count = JSON_LENGTH(p_items_json);

  -- Validasi stok sebelum transaksi
  check_loop: WHILE v_i < v_count DO
    SET v_product_id = JSON_UNQUOTE(JSON_EXTRACT(p_items_json, CONCAT('$[', v_i, '].product_id')));
    SET v_qty        = JSON_UNQUOTE(JSON_EXTRACT(p_items_json, CONCAT('$[', v_i, '].quantity')));
    SELECT stock INTO v_stock FROM products WHERE id = v_product_id AND is_active = 1;
    IF v_stock IS NULL THEN
      SET p_error = CONCAT('Produk ID ', v_product_id, ' tidak ditemukan');
      LEAVE check_loop;
    END IF;
    IF v_stock < v_qty THEN
      SELECT name INTO v_product_name FROM products WHERE id = v_product_id;
      SET p_error = CONCAT('Stok ', v_product_name, ' tidak mencukupi (tersisa: ', v_stock, ')');
      LEAVE check_loop;
    END IF;
    SET v_i = v_i + 1;
  END WHILE;

  IF p_error != '' THEN
    SET p_trx_id = 0;
  ELSE
    START TRANSACTION;

    -- Insert header transaksi
    INSERT INTO transactions
      (invoice_number, cashier_id, subtotal, tax_amount, discount_amount,
       total_amount, paid_amount, change_amount, payment_method)
    VALUES
      (p_invoice, p_cashier_id, p_subtotal, p_tax, p_discount,
       p_total, p_paid, p_change, p_method);

    SET p_trx_id = LAST_INSERT_ID();
    SET v_i = 0;

    -- Insert items + update stok
    WHILE v_i < v_count DO
      SET v_product_id   = JSON_UNQUOTE(JSON_EXTRACT(p_items_json, CONCAT('$[', v_i, '].product_id')));
      SET v_product_name = JSON_UNQUOTE(JSON_EXTRACT(p_items_json, CONCAT('$[', v_i, '].product_name')));
      SET v_price        = JSON_UNQUOTE(JSON_EXTRACT(p_items_json, CONCAT('$[', v_i, '].price')));
      SET v_qty          = JSON_UNQUOTE(JSON_EXTRACT(p_items_json, CONCAT('$[', v_i, '].quantity')));

      INSERT INTO transaction_items
        (transaction_id, product_id, product_name, product_price, quantity, subtotal)
      VALUES
        (p_trx_id, v_product_id, v_product_name, v_price, v_qty, v_price * v_qty);

      -- Update stok & catat log
      SELECT stock INTO v_stock FROM products WHERE id = v_product_id;
      UPDATE products SET stock = stock - v_qty, updated_at = NOW() WHERE id = v_product_id;
      INSERT INTO stock_logs (product_id, change_type, qty_before, qty_change, qty_after, reference, cashier_id)
      VALUES (v_product_id, 'sale', v_stock, -v_qty, v_stock - v_qty, p_invoice, p_cashier_id);

      SET v_i = v_i + 1;
    END WHILE;

    COMMIT;
  END IF;
END$$
DELIMITER ;

-- ============================================================
-- SEED DATA
-- ============================================================

-- Kategori
INSERT INTO categories (name, icon, sort_order) VALUES
  ('Minuman',    '🥤', 1),
  ('Makanan',    '🍜', 2),
  ('Snack',      '🍪', 3),
  ('Kebersihan', '🧼', 4),
  ('Rokok',      '🚬', 5),
  ('Susu',       '🥛', 6),
  ('Kesehatan',  '💊', 7);

-- Kasir default
INSERT INTO cashiers (name, username, pin, role) VALUES
  ('Administrator', 'admin', '123456', 'admin'),
  ('Andi Setiawan', 'andi', '111111', 'cashier'),
  ('Budi Santoso',  'budi', '222222', 'cashier');

-- Master Produk
INSERT INTO products (category_id, barcode, name, price, cost_price, stock, min_stock, unit, emoji, promo_label) VALUES
  (1,'8999999010011','Aqua 600ml',             4000, 2800,  50, 10, 'botol', '💧', NULL),
  (1,'8999999010012','Teh Botol 350ml',         5500, 3500,  30,  8, 'botol', '🍵', 'PROMO'),
  (1,'8999999010013','Coca-Cola 390ml',          7500, 5500,  25,  8, 'kaleng','🥤', NULL),
  (1,'8999999010014','Pocari Sweat 500ml',       9000, 6500,  20,  5, 'botol', '🍶', NULL),
  (1,'8999999010015','Good Day Coffee 250ml',    6500, 4500,  18,  5, 'kaleng','☕', NULL),
  (1,'8999999010016','Mizone 500ml',             8000, 5800,  15,  5, 'botol', '🧴', 'BOGO'),
  (2,'8999999020011','Indomie Goreng',            3500, 2500, 100, 20, 'bungkus','🍜', NULL),
  (2,'8999999020012','Pop Mie Ayam',              4500, 3200,  60, 15, 'cup',   '🍲', NULL),
  (2,'8999999020013','Richeese Nabati',           8000, 5800,  40, 10, 'bungkus','🧀', 'PROMO'),
  (2,'8999999020014','Sari Roti Tawar',          16500,12000,  12,  5, 'bungkus','🍞', NULL),
  (3,'8999999030011','Chitato 55gr',             12000, 8500,  35, 10, 'bungkus','🥔', NULL),
  (3,'8999999030012','Cheetos 55gr',             11000, 8000,  28, 10, 'bungkus','🌽', '2+1'),
  (3,'8999999030013','Oreo Original',             5500, 4000,  45, 10, 'bungkus','🍪', NULL),
  (3,'8999999030014','Biskuat 6pcs',              7500, 5500,  22,  8, 'bungkus','🌾', NULL),
  (4,'8999999040011','Lifebuoy Sabun',            6000, 4200,  30,  8, 'buah',  '🧼', NULL),
  (4,'8999999040012','Pepsodent 75gr',           10500, 7500,  25,  8, 'tube',  '🦷', 'PROMO'),
  (4,'8999999040013','Rinso Sachet',              2000, 1400,  60, 15, 'sachet','🫧', NULL),
  (5,'8999999050011','Gudang Garam 12',          24000,19500,  50, 10, 'bungkus','🚬', NULL),
  (5,'8999999050012','Sampoerna Mild 16',        27000,22000,  45, 10, 'bungkus','🚬', NULL),
  (6,'8999999060011','Ultra Milk Full Cream',     5500, 4000,  30,  8, 'kotak', '🥛', NULL),
  (6,'8999999060012','Indomilk Coklat 200ml',    5000, 3500,  35, 10, 'kotak', '🍫', 'PROMO'),
  (6,'8999999060013','Dancow Sachet',             9500, 7000,  20,  5, 'sachet','🥛', NULL),
  (7,'8999999070011','Panadol 4 Tablet',          8000, 5500,  40, 10, 'strip', '💊', NULL),
  (7,'8999999070012','Tolak Angin Sachet',        4500, 3200,  25,  8, 'sachet','🌿', NULL),
  (7,'8999999070013','Betadine 5ml',             11000, 8000,  15,  5, 'botol', '🩹', NULL);

-- ============================================================
-- MIGRASI: Tambah kolom image_url jika database sudah ada
-- Jalankan query ini jika sebelumnya sudah install tanpa kolom image_url
-- ============================================================
-- ALTER TABLE products ADD COLUMN image_url VARCHAR(300) DEFAULT NULL
--   COMMENT 'Path gambar produk (/uploads/namafile.jpg)'
--   AFTER emoji;
