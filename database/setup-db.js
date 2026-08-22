// database/setup-db.js — Setup database lokal untuk installer
// - Membuat database jika belum ada
// - Import schema.sql (mendukung blok DELIMITER / stored procedure)
// - Aman dijalankan berulang: kalau data sudah ada, import dilewati
// - Opsi --reset : hapus database lalu import ulang dari awal
const path = require('path');
const fs = require('fs');

// Env dibaca dari backend/.env
try { require('dotenv').config({ path: path.join(__dirname, '..', 'backend', '.env') }); } catch (e) {}

// mysql2 diambil dari node_modules backend (installer tidak install terpisah)
let mysql;
try { mysql = require('mysql2/promise'); }
catch (e) { mysql = require(path.join(__dirname, '..', 'backend', 'node_modules', 'mysql2', 'promise')); }

// ── Parser schema.sql: pecah jadi statement, dukung DELIMITER ──
function parseSchema(sql) {
  const re = /DELIMITER\s+(\S+)/gi;
  let delim = ';';
  let lastIdx = 0;
  const segments = [];
  let m;
  while ((m = re.exec(sql)) !== null) {
    segments.push({ text: sql.slice(lastIdx, m.index), delim });
    delim = m[1];
    lastIdx = re.lastIndex;
  }
  segments.push({ text: sql.slice(lastIdx), delim });

  const statements = [];
  for (const seg of segments) {
    for (let part of seg.text.split(seg.delim)) {
      // buang baris komentar penuh & kosong
      const cleaned = part.split(/\r?\n/).filter((l) => !/^\s*--/.test(l) && l.trim() !== '').join('\n').trim();
      if (!cleaned) continue;
      statements.push({ body: cleaned, delim: seg.delim });
    }
  }
  return statements;
}

(async () => {
  const reset = process.argv.includes('--reset');

  const cfg = {
    host: process.env.DB_HOST || 'localhost',
    port: Number(process.env.DB_PORT || 3306),
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
  };
  const DB = process.env.DB_NAME || 'alfamart_pos';

  console.log('==========================================');
  console.log('   ALFAMART POS - SETUP DATABASE');
  console.log(`   Server : ${cfg.host}:${cfg.port}`);
  console.log(`   User   : ${cfg.user}`);
  console.log(`   Database: ${DB}${reset ? ' (RESET)' : ''}`);
  console.log('==========================================');

  const conn = await mysql.createConnection(cfg);

  if (reset) {
    await conn.query(`DROP DATABASE IF EXISTS \`${DB}\``);
    console.log('[OK] Database lama dihapus (--reset)');
  }

  // Sudah ada & sudah terisi? -> lewati import
  const [t] = await conn.query(
    "SELECT COUNT(*) AS n FROM information_schema.tables WHERE table_schema = ? AND table_name = 'products'",
    [DB]
  );
  if (t[0].n === 0) {
    await conn.query(`CREATE DATABASE IF NOT EXISTS \`${DB}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci`);
    await conn.query('USE `' + DB + '`');
  } else {
    await conn.query('USE `' + DB + '`');
    const [c] = await conn.query('SELECT COUNT(*) AS n FROM products');
    if (c[0].n > 0) {
      console.log('[OK] Database sudah terisi data — import dilewati.');
      console.log('     Untuk mulai dari awal jalankan dengan opsi --reset');
      await conn.end();
      return;
    }
  }

  console.log('[..] Mengimpor schema + data seed ...');
  const sql = fs.readFileSync(path.join(__dirname, 'schema.sql'), 'utf8');

  // Buang CREATE DATABASE / USE bawaan schema (sudah ditangani script ini)
  const statements = parseSchema(sql).filter((s) => {
    const head = s.body.slice(0, 30).toUpperCase();
    return !head.startsWith('CREATE DATABASE') && !head.startsWith('USE ');
  });

  for (const s of statements) {
    await conn.query(s.body);
  }

  const [[cat]] = await conn.query('SELECT COUNT(*) AS n FROM categories');
  const [[pro]] = await conn.query('SELECT COUNT(*) AS n FROM products');
  const [[kas]] = await conn.query('SELECT COUNT(*) AS n FROM cashiers');
  console.log(`[OK] Import selesai: ${cat.n} kategori, ${pro.n} produk, ${kas.n} kasir.`);
  console.log('');
  console.log('SELESAI! Jalankan installer/start.bat untuk mulai berjualan.');

  await conn.end();
})().catch((e) => {
  console.error('[X] GAGAL: ' + e.message);
  console.error('     Pastikan MySQL/XAMPP sudah RUNNING dan kredensial di backend/.env benar.');
  process.exit(1);
});
