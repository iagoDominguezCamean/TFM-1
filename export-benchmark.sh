#!/bin/bash
set -e

RESULT_DIR=$1
OUT="$RESULT_DIR/results.csv"

echo "metric,value" > "$OUT"

# ---------- iperf3 ----------
IPERF_LINE=$(grep "^\[SUM\]" "$RESULT_DIR/iperf.txt" | tail -n1)
IPERF_VALUE=$(echo "$IPERF_LINE" | grep -oE '[0-9.]+[[:space:]]+[KMG]bits/sec')

: "${IPERF_VALUE:?iperf throughput not found}"

echo "iperf_throughput,$IPERF_VALUE" >> "$OUT"

# ---------- fortio (seconds → milliseconds) ----------
P50_SEC=$(grep "^# target 50%" "$RESULT_DIR/fortio.txt" | tail -n1 | awk '{print $4}')
P90_SEC=$(grep "^# target 90%" "$RESULT_DIR/fortio.txt" | tail -n1 | awk '{print $4}')
P99_SEC=$(grep "^# target 99%" "$RESULT_DIR/fortio.txt" | tail -n1 | awk '{print $4}')

: "${P50_SEC:?fortio p50 not found}"
: "${P90_SEC:?fortio p90 not found}"
: "${P99_SEC:?fortio p99 not found}"

P50_MS=$(awk "BEGIN {printf \"%.3f\", $P50_SEC * 1000}")
P90_MS=$(awk "BEGIN {printf \"%.3f\", $P90_SEC * 1000}")
P99_MS=$(awk "BEGIN {printf \"%.3f\", $P99_SEC * 1000}")

echo "http_p50_latency_ms,$P50_MS" >> "$OUT"
echo "http_p90_latency_ms,$P90_MS" >> "$OUT"
echo "http_p99_latency_ms,$P99_MS" >> "$OUT"

echo "CSV exported to $OUT"