#!/usr/bin/env python3

import subprocess
import time
import json

with open("mapping.json", "r") as f:
    VM_MAP = json.load(f)

NAMESPACE = "virt"

PING_INTERVAL = 5          # seconds (fixed)
PING_TIMEOUT = 2           # ping -W
FAILURE_WINDOW = 600       # 10 minutes
SUCCESS_LIMIT = 10         # stop pinging after 10 successes

state = {}
now = lambda: int(time.time())

for ip in VM_MAP:
    state[ip] = {
        "first_fail": None,
        "success": 0,
        "disabled": False,
    }


def ping(ip: str) -> bool:
    return subprocess.run(
        ["ping", "-c", "1", "-W", str(PING_TIMEOUT), ip],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    ).returncode == 0


def delete_vmi(vmi: str):
    print(f"🗑 Deleting VMI: {vmi}")
    subprocess.run(
        ["kubectl", "delete", "vmi", vmi, "-n", NAMESPACE],
        check=False,
    )


while True:
    active = False
    ts = now()

    for ip, vmi in VM_MAP.items():
        s = state[ip]

        if s["disabled"]:
            continue

        active = True
        print(f"🔍 Pinging {ip} ({vmi})")

        if ping(ip):
            s["success"] += 1
            s["first_fail"] = None
            print(f"✅ {ip} success {s['success']}/{SUCCESS_LIMIT}")

            if s["success"] >= SUCCESS_LIMIT:
                s["disabled"] = True
                print(f"🛑 {ip} disabled after {SUCCESS_LIMIT} successes")

        else:
            if s["first_fail"] is None:
                s["first_fail"] = ts
                print(f"⚠️ First failure for {ip}")
            else:
                failed_for = ts - s["first_fail"]
                print(f"❌ {ip} failing for {failed_for}s")

                if failed_for >= FAILURE_WINDOW:
                    print(f"🚨 {ip} failed continuously for 10 minutes")
                    delete_vmi(vmi)
                    s["disabled"] = True

    if not active:
        print("✅ All IPs are disabled. Exiting.")
        break

    time.sleep(PING_INTERVAL)