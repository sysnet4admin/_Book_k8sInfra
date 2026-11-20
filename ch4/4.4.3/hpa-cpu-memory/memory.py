#!/usr/bin/env python3
import time

tmp_array = [0]*1000000

with open("/proc/1/fd/1", "w") as f:
    print("Memory test started, wait for 5minutes", file=f)
    f.flush()

print("Content-Type: text/html")
print()
time.sleep(300)

with open("/proc/1/fd/1", "w") as f:
    print("Memory test finished", file=f)
    f.flush()

print("memory test finished")
