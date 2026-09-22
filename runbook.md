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
Jadwal produksi yang disarankan: cron harian + retensi 7 hari (contoh di `cron.example`).

## Troubleshooting (15 entri ringkas)

| # | Gejala | Penyebab | Fix |
|---|---|---|---|
| 1 | `IDX10720` saat login | JWT_SECRET < 256 bit | pakai ≥32 char acak |
| 2 | `Missing config: DB_CONN` | content-root salah saat run DLL | run dari folder DLL / set workdir compose |
| 3 | EF `NU1605 downgrade` | Pomelo vs EF beda minor | samakan 8.0.x (Pomelo 8.0.3 + EF 8.0.13) |
| 4 | Blazor login bounce /login→/→/login | guard + prerender tanpa JS | `prerender:false` + session storage + forceLoad |
| 5 | Drawer/layout tak reaktif | rendermode di layout merusak MudBlazor | interactive islands (`UserMenu`, `AuthNav`) |
| 6 | MudBlazor JS 404 | content-root salah | workdir = folder publish |
| 7 | MudBlazor 9 vs net8 | v9 butuh net lebih baru | pin 8.13.0 |
| 8 | CORS Telegram web 401/CORS | FRONTEND_URL tak set | samakan origin web |
| 9 | MySQL port bentrok 3306 | MariaDB dev sudah pakai | pakai 3308 untuk kos |
| 10 | Seed dobel (duplikat periode) | generate 2x | generate idempoten (cek Exists) |
| 11 | Newman 401 massal | DB direset, token basi | login ulang (token per-run) |
| 12 | Playwright flaky date | tanggal hardcode basi | pakai periode dinamis 2099 |
| 13 | `dotnet ef` tak ketemu | tool belum install | `dotnet tool install -g dotnet-ef --version 8.0.13` |
| 14 | Fonnte 401 | token salah/expired | regenerate dashboard Fonnte |
| 15 | Telegram `chat not found` | user belum /start | user /start dulu, ambil via getUpdates |
| 16 | MudDialog/Snackbar tak muncul | provider Mud* statis di layout | island `Providers.razor` interaktif |
| 17 | MudDrawer selalu overlay | Mini + Open=true + tanpa subscription | rail custom + `UiState` + offset appbar 64px |
| 18 | Login bounce /login→/→/login | guard + prerender tanpa JS | `prerender:false` + session + forceLoad |
| 19 | Shell hang saat `setsid...& disown` | `disown` tanpa job control | pakai `nohup ... &` langsung (tanpa disown) |
| 20 | MiniProfiler 404 | lupa `UseMiniProfiler()` / route | `RouteBasePath = "/profiler"` + middleware sebelum auth |
