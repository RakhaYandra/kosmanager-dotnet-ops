"""tickets.yaml -> KosManager-Tickets.xlsx"""
import os
import yaml
from openpyxl import Workbook
from openpyxl.styles import Font

base = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
tickets = yaml.safe_load(open(f"{base}/tickets.yaml"))

wb = Workbook()
ws = wb.active
ws.title = "Tickets"
ws.append(["ID", "Severity", "Title", "Repro", "Fix", "Prevention", "Status"])
for c in ws[1]:
    c.font = Font(bold=True)
for t in tickets:
    ws.append([t["id"], t["severity"], t["title"], t["repro"], t["fix"], t["prevention"], t["status"]])
wb.save(f"{base}/KosManager-Tickets.xlsx")
print(f"saved, {len(tickets)} tickets")
