# SLA mini — KosManager (lingkup demo/lokal)

Tanpa deploy produksi, SLA ini mengikat *kualitas rilis*, bukan uptime server.

| Area | Target |
|---|---|
| Kontrak API | Newman 25/25 tiap push (gagal = rilis ditahan) |
| QA | 50/50 cases + e2e 12/12 + UI 9/9 tiap rilis |
| Secrets | grep bersih tiap commit ke main |
| Backup | roundtrip `COUNT prod == COUNT restore` sebelum operasi destruktif |
| Reminder | tidak ada duplikat stage per tagihan (diuji TC-NOTIFY-03) |
| Response lokal | p95 < 500ms (pantau via MiniProfiler `/profiler/results`) |

*Upgrade ke SLA produksi (uptime, MTTR, on-call) hanya relevan setelah ada deploy —
sengaja tidak diklaim di sini.*
