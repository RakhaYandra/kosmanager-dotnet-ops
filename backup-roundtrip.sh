#!/usr/bin/env bash
# Backup roundtrip KosManager MySQL: backup -> drop tabel bukti -> restore -> verifikasi.
# Kredensial dibaca dari env. Lihat .env.example.
set -euo pipefail

C="${MYSQL_CONTAINER:-kosmanager-mysql}"
DB="${MYSQL_DATABASE:-kosmanager}"
STAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_DIR="${BACKUP_DIR:-/tmp}"
OUT="$BACKUP_DIR/backup-$STAMP.sql"

: "${MYSQL_PASSWORD:?set MYSQL_PASSWORD}"
: "${MYSQL_ROOT_PASSWORD:?set MYSQL_ROOT_PASSWORD}"

# MYSQL_PWD lebih aman daripada -p<pass> di command line (tidak muncul di ps).
export MYSQL_PWD="$MYSQL_PASSWORD"
export MYSQL_ROOT_PWD="$MYSQL_ROOT_PASSWORD"

echo "[1/4] backup -> $OUT"
docker exec -e MYSQL_PWD="$MYSQL_PASSWORD" "$C" \
  mysqldump -u"$MYSQL_USER" "$DB" > "$OUT"

echo "[2/4] uji hapus 1 baris Bills (transaksi, rollback)"
docker exec -e MYSQL_PWD="$MYSQL_PASSWORD" "$C" \
  mysql -u"$MYSQL_USER" "$DB" \
  -e "START TRANSACTION; DELETE FROM Bills LIMIT 1; SELECT COUNT(*) FROM Bills; ROLLBACK;"

echo "[3/4] restore dari $OUT ke DB uji"
docker exec -e MYSQL_PWD="$MYSQL_ROOT_PASSWORD" "$C" \
  mysql -uroot -e "CREATE DATABASE IF NOT EXISTS ${DB}_restore;"
docker exec -i -e MYSQL_PWD="$MYSQL_ROOT_PASSWORD" "$C" \
  mysql -uroot "${DB}_restore" < "$OUT"

echo "[4/4] verifikasi jumlah Bills sama"
A=$(docker exec -e MYSQL_PWD="$MYSQL_PASSWORD" "$C" \
  mysql -u"$MYSQL_USER" "$DB" -N -e "SELECT COUNT(*) FROM Bills;")
B=$(docker exec -e MYSQL_PWD="$MYSQL_ROOT_PASSWORD" "$C" \
  mysql -uroot "${DB}_restore" -N -e "SELECT COUNT(*) FROM Bills;")
echo "prod=$A restore=$B"
[ "$A" = "$B" ] && echo "ROUNDTRIP OK" || (echo "MISMATCH"; exit 1)

docker exec -e MYSQL_PWD="$MYSQL_ROOT_PASSWORD" "$C" \
  mysql -uroot -e "DROP DATABASE ${DB}_restore;"

echo "backup tetap di $OUT (hapus manual bila tidak perlu)"
