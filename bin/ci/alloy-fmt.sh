#!/bin/bash
set -euo pipefail

for f in *.alloy; do
  alloy fmt $f >/dev/null
done
