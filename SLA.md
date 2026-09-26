# SLA mini — KosManager (lingkup demo/lokal)

Tanpa deploy produksi, SLA ini mengikat *kualitas rilis*, bukan uptime server.

| Area | Target |
|---|---|
| Kontrak API | Newman 25/25 tiap push (gagal = rilis ditahan) |
| QA | 54/54 cases + e2e 12/12 tiap rilis |
| Secrets | grep bersih tiap commit ke main |
| Backup | roundtrip `COUNT prod == COUNT restore` sebelum operasi destruktif |

Angka QA di sini mengikuti [kosmanager-dotnet-qa](https://github.com/RakhaYandra/kosmanager-dotnet-qa)
(tabel Metrik) — sumber kebenaran tunggal, bukan salinan.
| Reminder | tidak ada duplikat stage per tagihan (diuji TC-NOTIFY-03) |
| Response lokal | p95 < 500ms (pantau via MiniProfiler `/profiler/results`) |

*Upgrade ke SLA produksi (uptime, MTTR, on-call) hanya relevan setelah ada deploy —
sengaja tidak diklaim di sini.*
