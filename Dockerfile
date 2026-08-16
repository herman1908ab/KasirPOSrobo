# ─────────────────────────────────────────────────────────
# Alfamart POS — Docker Image
# Build dari root proyek (backend + frontend tetap 1 level
# supaya path '../frontend' & '../frontend/uploads' tetap valid)
# ─────────────────────────────────────────────────────────
FROM node:20-alpine

WORKDIR /app

# Install dependencies backend dulu (cache layer)
COPY backend/package*.json ./backend/
RUN cd backend && npm ci --omit=dev && npm cache clean --force

# Salin source code backend + frontend
COPY backend ./backend
COPY frontend ./frontend

# Seed gambar uploads (dipisah, supaya bisa di-copy ke volume saat start)
COPY frontend/uploads ./seed-uploads

WORKDIR /app/backend

ENV NODE_ENV=production
EXPOSE 4000

# PORT diisi otomatis oleh hosting (Railway/Render/Koyeb)
CMD ["node", "server.js"]
