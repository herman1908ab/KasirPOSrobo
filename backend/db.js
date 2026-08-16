// db.js — MySQL connection pool
const mysql = require('mysql2/promise');
require('dotenv').config();

const pool = mysql.createPool({
  host:              process.env.DB_HOST     || 'localhost',
  port:              process.env.DB_PORT     || 3306,
  user:              process.env.DB_USER     || 'root',
  password:          process.env.DB_PASSWORD || '',
  database:          process.env.DB_NAME     || 'alfamart_pos',
  charset:           'utf8mb4',
  waitForConnections: true,
  connectionLimit:   10,
  queueLimit:        0,
  timezone:          '+07:00',       // WIB
});

// Test koneksi saat startup
pool.getConnection()
  .then(conn => {
    console.log('✅ MySQL terhubung:', process.env.DB_NAME);
    conn.release();
  })
  .catch(err => {
    console.error('❌ MySQL gagal konek:', err.message);
    process.exit(1);
  });

module.exports = pool;
