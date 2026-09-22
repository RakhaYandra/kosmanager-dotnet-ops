#!/usr/bin/env bash
# Backup roundtrip KosManager MySQL: backup -> drop tabel bukti -> restore -> verifikasi.
set -euo pipefail
C="kosmanager-mysql"
STAMP=$(date +%Y%m%d-%H%M%S)
OUT="backup-$STAMP.sql"
echo "[1/4] backup -> $OUT"
docker exec "$C" mysqldump -ukos -pkospass kosmanager > "$OUT"
echo "[2/4] uji hapus 1 baris Bills (transaksi, rollback)"
docker exec "$C" mysql -ukos -pkospass kosmanager -e "START TRANSACTION; DELETE FROM Bills LIMIT 1; SELECT COUNT(*) FROM Bills; ROLLBACK;"
echo "[3/4] restore dari $OUT ke DB uji"
docker exec "$C" mysql -uroot -prootpass -e "CREATE DATABASE IF NOT EXISTS kosmanager_restore;"
docker exec -i "$C" mysql -uroot -prootpass kosmanager_restore < "$OUT"
echo "[4/4] verifikasi jumlah Bills sama"
A=$(docker exec "$C" mysql -ukos -pkospass kosmanager -N -e "SELECT COUNT(*) FROM Bills;")
B=$(docker exec "$C" mysql -uroot -prootpass kosmanager_restore -N -e "SELECT COUNT(*) FROM Bills;")
echo "prod=$A restore=$B"
[ "$A" = "$B" ] && echo "ROUNDTRIP OK" || (echo "MISMATCH"; exit 1)
docker exec "$C" mysql -uroot -prootpass -e "DROP DATABASE kosmanager_restore;"
