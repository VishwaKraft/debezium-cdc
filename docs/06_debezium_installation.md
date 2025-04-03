# Debezium Installation Guide

## What is Debezium?
Debezium is an open-source distributed **Change Data Capture (CDC)** platform that allows applications to track changes in databases in real time. It captures changes from database logs and streams them into Kafka topics, making them available for consumers like ClickHouse, Elasticsearch, or other applications.

📖 **Reference:** [Debezium Official Documentation](https://debezium.io/documentation/reference/3.1/)

## Why Use Debezium?
Debezium enables real-time data synchronization and event-driven architectures with:
- **Low Latency**: Captures and streams database changes instantly.
- **Reliability**: Ensures consistency by reading transaction logs instead of querying the database.
- **Scalability**: Works efficiently with distributed architectures.
- **Flexibility**: Supports various databases like MySQL, PostgreSQL, SQL Server, and MongoDB.

📖 **Reference:** [Introduction to Debezium](https://debezium.io/documentation/reference/3.1/introduction.html)

## Installation Methods
Debezium can be installed in different ways, depending on the setup requirements:

### 1. Using Docker (Recommended)
This is the easiest and most portable way to run Debezium. It requires **Kafka** and **Kafka Connect**.

### 2. Running as a Standalone Service
Debezium can be run as an independent service with its own configuration and logging setup.

### 3. Using Kafka Connect (Embedded)
Debezium runs as a Kafka Connect source connector, making it easy to integrate with Kafka-based architectures.

## Setting Up Debezium with Docker Compose
Create a `docker-compose.yml` file to set up Debezium with Kafka, Zookeeper, and Kafka Connect.

```yaml
version: '3.7'
services:
  zookeeper:
    image: confluentinc/cp-zookeeper:latest
    container_name: zookeeper
    restart: unless-stopped
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181

  kafka:
    image: confluentinc/cp-kafka:latest
    container_name: kafka
    restart: unless-stopped
    depends_on:
      - zookeeper
    environment:
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka:9092
      KAFKA_BROKER_ID: 1
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
    ports:
      - "9092:9092"

  connect:
    image: debezium/connect:latest
    container_name: kafka-connect
    restart: unless-stopped
    depends_on:
      - kafka
    environment:
      BOOTSTRAP_SERVERS: kafka:9092
      GROUP_ID: "debezium"
      CONFIG_STORAGE_TOPIC: "connect_configs"
      OFFSET_STORAGE_TOPIC: "connect_offsets"
      STATUS_STORAGE_TOPIC: "connect_status"
    ports:
      - "8083:8083"
```

Start the services:
```sh
docker-compose up -d
```

📖 **Reference:** [Debezium with Docker](https://debezium.io/documentation/reference/3.1/operations/installation.html)

## Configuring the Debezium Connector for MySQL
Once Debezium is running, register the MySQL connector using the following JSON configuration (`mysql-connector.json`):

```json
{
  "name": "inventory-connector",
  "config": {
    "connector.class": "io.debezium.connector.mysql.MySqlConnector",
    "database.hostname": "mysql",
    "database.port": "3306",
    "database.user": "debezium",
    "database.password": "dbz",
    "database.server.id": "184054",
    "database.include.list": "inventory",
    "database.history.kafka.bootstrap.servers": "kafka:9092",
    "database.history.kafka.topic": "schema-changes.inventory"
  }
}
```

Register the connector:
```sh
curl -X POST -H "Content-Type: application/json" --data @mysql-connector.json http://localhost:8083/connectors
```

📖 **Reference:** [Debezium MySQL Connector](https://debezium.io/documentation/reference/3.1/connectors/mysql.html)

## Verifying Debezium is Capturing Changes
To ensure Debezium is capturing changes:
1. **Check Registered Connectors**
   ```sh
   curl -s http://localhost:8083/connectors | jq .
   ```
2. **Consume Kafka Messages**
   ```sh
   docker run --rm --net=host confluentinc/cp-kafkacat kafkacat -b localhost:9092 -t inventory -C -o beginning
   ```

📖 **Reference:** [Debezium Monitoring](https://debezium.io/documentation/reference/3.1/operations/monitoring.html)

## Best Practices and Considerations
- **Ensure binlogs are enabled** in MySQL for CDC to work.
- **Use separate Kafka topics** for different tables to improve scalability.
- **Monitor Kafka and Debezium** using Prometheus and Grafana.
- **Fine-tune Kafka retention policies** for better performance.

📖 **Further Reading:**
- [Debezium Configuration](https://debezium.io/documentation/reference/3.1/configuration.html)
- [Kafka Connect Configuration](https://docs.confluent.io/platform/current/connect/index.html)
- [MySQL Binlog Setup](https://dev.mysql.com/doc/refman/8.0/en/binary-log.html)

