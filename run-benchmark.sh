#!/bin/bash
set -e

RESULTS_DIR="benchmark/results"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")

OUT_DIR="$RESULTS_DIR/$1-$TIMESTAMP"
mkdir -p $OUT_DIR

echo "Running benchmark on cluster: $1"
echo "Results will be stored in $OUT_DIR"

# --- IPERF TEST ---
echo "Running iperf3 throughput test..."

IPERF_SERVER_IP=$(kubectl --kubeconfig="/home/iagodc/.kube/$1" get pod iperf-server -n benchmark -o jsonpath='{.status.podIP}')

kubectl --kubeconfig="/home/iagodc/.kube/$1" exec -n benchmark iperf-client -- \
  iperf3 -c $IPERF_SERVER_IP -t 60 -P 4 \
  | tee $OUT_DIR/iperf.txt

# --- FORTIO TEST ---
echo "Running fortio HTTP latency test..."

# FORTIO_SERVER_IP=$(kubectl --kubeconfig="/home/iagodc/.kube/$1" get pod fortio-server -n benchmark -o jsonpath='{.status.podIP}')

kubectl --kubeconfig="/home/iagodc/.kube/$1" exec -n benchmark fortio-client -- \
  fortio load -qps 200 -t 60s http://fortio-server:8080 \
  2>&1 | tee $OUT_DIR/fortio.txt

# --- METRICS ---
echo "Collecting resource metrics..."

kubectl --kubeconfig="/home/iagodc/.kube/$1" top nodes | tee $OUT_DIR/nodes.txt
kubectl --kubeconfig="/home/iagodc/.kube/$1" top pods  | tee $OUT_DIR/app-pods.txt
kubectl --kubeconfig="/home/iagodc/.kube/$1" top pods -n benchmark | tee $OUT_DIR/benchmark-pods.txt

echo "Benchmark completed."
