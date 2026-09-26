# KosManager Ops Runbook

## Up (5 menit)

```bash
JWT_SECRET=$(openssl rand -hex 32) docker compose up --build -d
docker compose exec api dotnet-ef database update  # atau via CI
```

Seed fiktif: lihat `kosmanager-dotnet/KosManager.Api/seed/seed.sql`.
Login demo: `owner@kos.local / owner123`.

## Backup

`./backup-roundtrip.sh` — mysqldump + restore ke DB uji + bandingkan COUNT.
Butuh `MYSQL_PASSWORD` + `MYSQL_ROOT_PASSWORD` di env (lihat `.env.example`).
Jadwal produksi yang disarankan — cron harian, retensi 7 hari:

```cron
17 3 * * * cd /path/ke/ops/repo && BACKUP_DIR=/var/backups/kos ./backup-roundtrip.sh >> /var/log/kos-backup.log 2>&1
```

## Troubleshooting (10 entri — hanya lapisan API & infra)

Entri frontend (MudBlazor, interactive islands, MiniProfiler) pindah ke
`kosmanager-dotnet-web/docs/ADR-004-frontend-fixes.md` §5. Entri suite QA
(Newman 401, Playwright flaky) pindah ke `kosmanager-dotnet-qa` `test-plan.md`.

| # | Gejala | Penyebab | Fix |
|---|---|---|---|
| 1 | `IDX10720` saat login | JWT_SECRET < 256 bit | pakai ≥32 char acak |
| 2 | `Missing config: DB_CONN` | content-root salah saat run DLL | run dari folder DLL / set workdir compose |
| 3 | EF `NU1605 downgrade` | Pomelo vs EF beda minor | samakan 8.0.x (Pomelo 8.0.3 + EF 8.0.13) |
| 4 | CORS Telegram web 401/CORS | FRONTEND_URL tak set | samakan origin web |
| 5 | MySQL port bentrok 3306 | MariaDB dev sudah pakai | pakai 3308 untuk kos |
| 6 | Seed dobel (duplikat periode) | generate 2x | generate idempoten (cek Exists) |
| 7 | `dotnet ef` tak ketemu | tool belum install | `dotnet tool install -g dotnet-ef --version 8.0.13` |
| 8 | Fonnte 401 | token salah/expired | regenerate dashboard Fonnte |
| 9 | Telegram `chat not found` | user belum /start | user /start dulu, ambil via getUpdates |
| 10 | Shell hang saat `setsid...& disown` | `disown` tanpa job control | pakai `nohup ... &` langsung (tanpa disown) |
