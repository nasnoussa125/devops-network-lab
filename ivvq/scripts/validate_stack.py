#!/usr/bin/env python3
"""
Script de validation locale IVVQ
Vérifie l'état de la stack de monitoring sans dépendance réseau externe.
Utilisé par Jenkins en complément des tests Robot Framework.
"""

import sys
import json
import urllib.request
import urllib.error

SERVICES = {
    "Prometheus": "http://localhost:9090/-/healthy",
    "Grafana":    "http://localhost:3000/api/health",
    "NodeExporter": "http://localhost:9100/metrics",
}

results = {}
all_ok = True

for name, url in SERVICES.items():
    try:
        with urllib.request.urlopen(url, timeout=5) as resp:
            status = resp.status
            ok = status == 200
    except urllib.error.URLError as e:
        status = str(e)
        ok = False

    results[name] = {"url": url, "status": status, "ok": ok}
    if not ok:
        all_ok = False


print("\n=== Rapport de validation IVVQ ===")
for name, r in results.items():
    text = "Success" if r["ok"] else "Fail"
    print(f"  {text}  {name:<20} → {r['status']}  ({r['url']})")

print("\n" + ("Succes :Services UP." if all_ok else "Failed service is DOWN."))
print("=" * 35 + "\n")


sys.exit(0 if all_ok else 1)
