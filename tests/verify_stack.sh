#!/bin/bash

set -e

echo "Verifying Docker Compose stack..."

PROMETHEUS_URL="http://localhost:9090"
NODE_EXPORTER_URL="http://localhost:9100"
GRAFANA_URL="http://localhost:3000"

check_endpoint() {
    local url=$1
    local name=$2
    
    echo -n "Checking $name... "
    if curl -sf "$url" > /dev/null; then
        echo "OK"
        return 0
    else
        echo "FAILED"
        return 1
    fi
}

check_endpoint "$PROMETHEUS_URL/-/healthy" "Prometheus health"
check_endpoint "$NODE_EXPORTER_URL/metrics" "Node Exporter metrics"
check_endpoint "$GRAFANA_URL/api/health" "Grafana health"

echo "All endpoints verified successfully"
