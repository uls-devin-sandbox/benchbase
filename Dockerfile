FROM openjdk:23-jdk-slim

# Install Maven and Git
RUN apt-get update && \
    apt-get install -y maven git && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Build the project with all profiles separately to avoid overwriting
RUN ./mvnw clean package -P yugabytedb -Dmaven.test.skip=true && \
    cp target/benchbase-2023-SNAPSHOT-yugabytedb.jar /tmp/benchbase-yugabytedb.jar && \
    ./mvnw package -P mysql -Dmaven.test.skip=true && \
    cp target/benchbase-2023-SNAPSHOT-mysql.jar /tmp/benchbase-mysql.jar && \
    ./mvnw package -P postgres -Dmaven.test.skip=true && \
    cp target/benchbase-2023-SNAPSHOT-postgres.jar /tmp/benchbase-postgres.jar && \
    cp /tmp/benchbase-yugabytedb.jar target/benchbase-2023-SNAPSHOT-yugabytedb.jar && \
    cp /tmp/benchbase-mysql.jar target/benchbase-2023-SNAPSHOT-mysql.jar

# Create benchmark script
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
DB_TYPE=$1\n\
CONFIG_FILE=$2\n\
\n\
if [ -z "$DB_TYPE" ] || [ -z "$CONFIG_FILE" ]; then\n\
    echo "Usage: $0 <db_type> <config_file>"\n\
    echo "Example: $0 yugabytedb config/yugabytedb/sample_tpcc_config.xml"\n\
    exit 1\n\
fi\n\
\n\
echo "Running TPC-C benchmark for $DB_TYPE..."\n\
\n\
# Wait for database to be ready\n\
sleep 10\n\
\n\
# Run benchmark\n\
java -jar target/benchbase-2023-SNAPSHOT-${DB_TYPE}.jar -b tpcc -c $CONFIG_FILE --create=true --load=true --execute=true\n\
' > /app/run_benchmark.sh && chmod +x /app/run_benchmark.sh

CMD ["bash"]
