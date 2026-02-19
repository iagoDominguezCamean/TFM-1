#!/bin/bash

RESULT_DIR=$1

echo "metric,value" > $RESULT_DIR/results.csv

# Extract iperf throughput
THROUGHPUT=$(grep -E "SUM.*receiver" $RESULT_DIR/iperf.txt | awk '{print $(NF-1)}')
UNIT=$(grep -E "SUM.*receiver" $RESULT_DIR/iperf.txt | awk '{print $NF}')
echo "iperf_throughput,$THROUGHPUT $UNIT" >> $RESULT_DIR/results.csv

# Extract fortio latency
P50=$(grep "50.0%" $RESULT_DIR/fortio.txt | awk '{print $3}')
P90=$(grep "90.0%" $RESULT_DIR/fortio.txt | awk '{print $3}')
P99=$(grep "99.0%" $RESULT_DIR/fortio.txt | awk '{print $3}')

echo "http_p50_latency,$P50" >> $RESULT_DIR/results.csv
echo "http_p90_latency,$P90" >> $RESULT_DIR/results.csv
echo "http_p99_latency,$P99" >> $RESULT_DIR/results.csv

echo "CSV exported to $RESULT_DIR/results.csv"
