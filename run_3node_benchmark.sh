#!/bin/bash
set -e

echo "=== YugabyteDB 3ノードクラスター TPC-Cベンチマーク実行スクリプト ==="

echo "3ノードYugabyteDBクラスターを起動中..."
docker-compose -f docker-compose-3node.yml up -d

echo "データベースの準備完了を待機中..."
sleep 60

echo "YugabyteDBクラスター状態を確認中..."
docker-compose -f docker-compose-3node.yml exec yugabytedb-node1 bin/ysqlsh -h localhost -p 5433 -U yugabyte -d yugabyte -c "SELECT * FROM yb_servers();"

run_benchmark() {
    local db_type=$1
    local config_file=$2
    local description=$3
    
    echo ""
    echo "=== $description ベンチマーク実行開始 ==="
    echo "データベース: $db_type"
    echo "設定ファイル: $config_file"
    echo "開始時刻: $(date)"
    
    docker-compose -f docker-compose-3node.yml exec benchbase bash -c "cd /tmp/benchbase-${db_type}/benchbase-${db_type} && java -jar benchbase.jar -b tpcc -c /app/$config_file --create=true --load=true --execute=true"
    
    echo "$description ベンチマーク完了: $(date)"
    echo ""
}

run_benchmark "yugabytedb" "config/yugabytedb/sample_tpcc_config.xml" "YugabyteDB 3ノードクラスター"
run_benchmark "mysql" "config/mysql/docker_tpcc_config.xml" "MySQL"
run_benchmark "postgres" "config/postgres/docker_tpcc_config.xml" "PostgreSQL"

echo "=== 全ベンチマーク完了 ==="
echo "結果ファイルは results/ ディレクトリに保存されています"
echo ""
echo "結果を確認するには:"
echo "  ls -la results/"
echo ""
echo "サービスを停止するには:"
echo "  docker-compose -f docker-compose-3node.yml down"
