# kosmanager-dotnet-ops

[![ci](https://github.com/RakhaYandra/kosmanager-dotnet-ops/actions/workflows/ci.yml/badge.svg)](https://github.com/RakhaYandra/kosmanager-dotnet-ops/actions)

> Ekosistem: [api](https://github.com/RakhaYandra/kosmanager-dotnet) · [web](https://github.com/RakhaYandra/kosmanager-dotnet-web) · [docs](https://github.com/RakhaYandra/kosmanager-dotnet-docs/releases) · [qa](https://github.com/RakhaYandra/kosmanager-dotnet-qa) · [data](https://github.com/RakhaYandra/kosmanager-dotnet-data) · [ops](https://github.com/RakhaYandra/kosmanager-dotnet-ops)

Operasional KosManager: runbook compose, skrip backup/restore MySQL teruji
roundtrip, troubleshooting matrix 10 entri terverifikasi, 4 tiket + XLSX,
SLA mini, FAQ.

## Purpose, Output & Expectations

**Purpose.** Stack API + MySQL + Blazor punya lebih banyak moving parts
dibanding 1 binary: container, volume, secret, dan JWT dev. Repo ini menjaga
stack tetap operable — termasuk pelajaran dari bug asli (JWT 256-bit,
Pomelo/EF downgrade, prerender-vs-session, shell hang).

**Output.** Runbook compose, skrip backup roundtrip teruji, matrix 20 entri,
4 tiket + XLSX, SLA mini, FAQ.

**Expectations.** Setelah baca: lifecycle compose, disiplin backup, dan
penyebab 5 bug terdokumentasi dipahami; restore roundtrip terbukti
(prod COUNT == restore COUNT).

## Features

| Fitur | Deskripsi |
|---|---|
| Runbook | Compose up/down, JWT dev, migrate+seed, backup/restore, rebuild. |
| Backup scripts | `backup-roundtrip.sh`: mysqldump → restore ke DB uji → bandingkan COUNT. |
| Troubleshooting | 10 entri terverifikasi (JWT, EF, Docker, Telegram, seed). Frontend di web repo, QA di qa repo. |
| Tickets | 4 tiket (severity → pencegahan). Output: `KosManager-Tickets.xlsx`. |
| SLA + FAQ | Target operasional + jawaban umum (tenor, CSV, reminder, cache). |

## How It Works

```text
Symptom --> compose ps + logs --> matrix --> known: runbook fix
                                        --> unknown: open ticket --> fix + verify
```

## Isi

```
runbook.md                 # lifecycle + troubleshooting 20 entri
SLA.md                     # target operasional
FAQ.md                     # jawaban umum
backup-roundtrip.sh        # mysqldump + restore + verifikasi COUNT
docker-compose.yml         # mysql + api (build dari repo api)
tickets.yaml -> tools/build_tickets.py -> KosManager-Tickets.xlsx
```

## Bukti uji

* Roundtrip: backup → restore ke DB uji → COUNT Bills prod == restore (terverifikasi real).
