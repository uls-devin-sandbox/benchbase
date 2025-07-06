#!/bin/bash

set -e

echo "=== BenchBase TPC-C Performance Comparison ==="
echo "Starting all database containers..."

docker-compose up -d

echo "Waiting for databases to be ready..."
sleep 30

run_benchmark() {
    local db_type=$1
    local config_file=$2
    local db_name=$3
    
    echo ""
    echo "=== Running TPC-C benchmark for $db_name ==="
    echo "Database: $db_name"
    echo "Config: $config_file"
    echo "Started at: $(date)"
    
    docker-compose exec benchbase ./run_benchmark.sh $db_type $config_file
    
    echo "Completed at: $(date)"
    echo "=== $db_name benchmark completed ==="
}

mkdir -p results

echo ""
echo "Starting benchmark execution..."

run_benchmark yugabytedb config/yugabytedb/sample_tpcc_config.xml "YugabyteDB"

run_benchmark mysql config/mysql/docker_tpcc_config.xml "MySQL"

run_benchmark postgres config/postgres/docker_tpcc_config.xml "PostgreSQL"

echo ""
echo "=== All benchmarks completed! ==="
echo "Results are available in the results/ directory"
echo ""
echo "To view results:"
echo "  docker-compose exec benchbase ls -la results/"
echo ""
echo "To stop all services:"
echo "  docker-compose down"
