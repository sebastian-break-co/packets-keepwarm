#!/usr/bin/env bash
# Pings the Packets sites so their serverless functions and Neon/Postgres databases stay awake.
# Usage: scripts/ping.sh [rounds] [seconds_between_rounds]    (defaults: 1 round)
# Every URL here is a public GET and carries no secret. Edit targets.txt to change what is pinged.
set -u
ROUNDS="${1:-1}"; GAP="${2:-60}"
DIR="$(cd "$(dirname "$0")/.." && pwd)"
fail=0
for ((r = 1; r <= ROUNDS; r++)); do
  while IFS= read -r url; do
    [[ -z "$url" || "$url" == \#* ]] && continue
    out=$(curl -sS -o /dev/null --max-time 30 --retry 1 -A "packets-keepwarm/1.0" \
      -w "%{http_code} ttfb=%{time_starttransfer}s" "$url" 2>&1) || out="curl failed: $out"
    echo "$(date -u +%H:%M:%S) $url -> $out"
    case "$out" in 2*|3*) ;; *) fail=$((fail + 1));; esac
  done < "$DIR/targets.txt"
  (( r < ROUNDS )) && sleep "$GAP"
done
# A failing site is reported in the log but must not make the whole run red every time.
echo "failed checks: $fail"
exit 0
