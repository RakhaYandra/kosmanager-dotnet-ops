# FAQ — KosManager

**Kapan tagihan dibuat?** Owner tekan Generate per periode (tenor tgl-10);
idempoten (periode sama 2x → kedua 0).

**Format CSV import?** `nama,no-hp,YYYY-MM-DD` per baris; laporan gagal per baris.

**Kenapa reminder belum masuk?** Cek: (1) tenant punya chat_id, (2) stage
H-3/H-1/H+1 sesuai tanggal, (3) channel mock vs telegram, (4) user /start
dulu untuk Telegram asli.

**Berapa lama data cache?** Dashboard 60 dtk, bills/queue 30 dtk; tulis
apa pun langsung invalidate (baca README API).

**Apakah data saya aman di demo?** Seed 100% fiktif; tanpa secret di repo;
token Telegram hanya env sesaat.

**Butuh server?** Tidak untuk demo lokal. Scheduler + webhook 24 jam butuh
server (Fase non-$0, belum dikerjakan).
