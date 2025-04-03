# ClickHouse Installation Guide

## What is ClickHouse?
ClickHouse is a **columnar database** designed for **high-performance analytics** and **real-time data processing**. It is optimized for OLAP (Online Analytical Processing) workloads and can process massive amounts of data efficiently.

📖 **Reference:** [ClickHouse Official Documentation](https://clickhouse.com/docs/en/)

## Why Use ClickHouse as a Sink?
ClickHouse is widely used as a **sink** in real-time data pipelines due to:
- **High Ingestion Performance**: Handles millions of events per second.
- **Columnar Storage**: Optimized for fast analytical queries.
- **Real-Time Processing**: Processes incoming data with low latency.
- **Efficient Compression**: Reduces storage costs while maintaining high-speed reads.
- **Scalability**: Supports horizontal and vertical scaling.

📖 **Reference:** [ClickHouse vs Traditional Databases](https://clickhouse.com/blog/why-clickhouse-is-so-fast)

## Installing ClickHouse

### 1. Using Docker Compose (Recommended)
To quickly set up ClickHouse, create a `docker-compose.yml` file:

```yaml
version: '3.7'
services:
  clickhouse:
    image: clickhouse/clickhouse-server:latest
    container_name: clickhouse
    restart: unless-stopped
    ports:
      - "8123:8123"  # HTTP Interface
      - "9000:9000"  # Native TCP Interface
    volumes:
      - clickhouse_data:/var/lib/clickhouse
      - ./clickhouse-config.xml:/etc/clickhouse-server/config.xml
    environment:
      CLICKHOUSE_USER: admin
      CLICKHOUSE_PASSWORD: admin

volumes:
  clickhouse_data:
```

Start ClickHouse using:
```sh
docker-compose up -d
```

📖 **Reference:** [ClickHouse Docker Setup](https://hub.docker.com/r/clickhouse/clickhouse-server)

### 2. Installing ClickHouse Manually
#### **For Ubuntu**
```sh
echo "deb http://repo.yandex.ru/clickhouse/deb/stable/ main/" | sudo tee /etc/apt/sources.list.d/clickhouse.list
sudo apt-get update
sudo apt-get install -y clickhouse-server clickhouse-client
sudo systemctl start clickhouse-server
```

#### **For macOS (Using Homebrew)**
```sh
brew install clickhouse
```

#### **For Windows (Using WSL or Docker)**
ClickHouse is not natively supported on Windows but can be run using WSL or Docker.
```sh
docker run -d --name clickhouse -p 8123:8123 -p 9000:9000 clickhouse/clickhouse-server
```

📖 **Reference:** [ClickHouse Installation Methods](https://clickhouse.com/docs/en/getting-started/install/)

## How ClickHouse Captures Data from Kafka and Debezium
ClickHouse can ingest data from Kafka topics **without an external connector** by using its built-in **Kafka Engine**.

### **How It Works:**
1. **Debezium Captures Changes from MySQL**
   - Debezium reads MySQL binlogs and sends **CDC events** to Kafka topics.
2. **Kafka Stores CDC Events**
   - Kafka acts as an event bus, ensuring reliability and scalability.
3. **ClickHouse Reads from Kafka Topics**
   - ClickHouse **directly reads Kafka messages** using the `Kafka Engine`.

📖 **Reference:** [Debezium Kafka Integration](https://debezium.io/documentation/reference/3.1/tutorial.html)

## Configuring ClickHouse Kafka Integration
To integrate ClickHouse with Kafka, create a **Kafka Engine table**.

### **Step 1: Create a Kafka Table in ClickHouse**
```sql
CREATE TABLE kafka_messages (
    id String,
    name String,
    email String,
    created_at DateTime
) ENGINE = Kafka
SETTINGS kafka_broker_list = 'kafka:9092',
         kafka_topic_list = 'db_cdc',
         kafka_format = 'JSONEachRow',
         kafka_group_name = 'clickhouse_cdc';
```

### **Step 2: Create a Target Table for Processed Data**
```sql
CREATE TABLE users (
    id String,
    name String,
    email String,
    created_at DateTime
) ENGINE = MergeTree()
ORDER BY id;
```

### **Step 3: Insert Kafka Data into ClickHouse Periodically**
```sql
INSERT INTO users SELECT * FROM kafka_messages;
```

📖 **Reference:** [ClickHouse Kafka Engine](https://clickhouse.com/docs/en/engines/table-engines/integrations/kafka)

## Kafka-ClickHouse Connector Configuration (Alternative Approach)
Alternatively, you can use **Kafka Connect** with a ClickHouse **JDBC Sink Connector**.

### **Kafka Connect Sink Configuration (`clickhouse-sink.json`)**
```json
{
  "name": "clickhouse-sink-connector",
  "config": {
    "connector.class": "com.clickhouse.kafka.connect.sink.ClickHouseSinkConnector",
    "topics": "db_cdc",
    "clickhouse.server.url": "jdbc:clickhouse://clickhouse:8123",
    "clickhouse.user": "admin",
    "clickhouse.password": "admin",
    "table.name.format": "users"
  }
}
```

### **Deploy the Connector**
1. Start Kafka Connect with the ClickHouse Sink Connector plugin.
2. Register the connector:
```sh
curl -X POST -H "Content-Type: application/json" \
--data @clickhouse-sink.json \
http://localhost:8083/connectors
```

📖 **Reference:** [Kafka Connect ClickHouse Sink](https://github.com/ClickHouse/clickhouse-kafka-connect)

## Why ClickHouse for CDC Pipelines?
- **Handles large-scale streaming data efficiently**.
- **High-speed ingestion with the Kafka engine**.
- **Cost-effective storage with columnar compression**.
- **Real-time analytics with optimized OLAP queries**.

📖 **Reference:** [ClickHouse for Streaming Data](https://clickhouse.com/blog/clickhouse-and-streaming-data)

## Next Steps
- Tune ClickHouse performance for production use.
- Set up **replication and sharding** for high availability.
- Monitor ClickHouse using **Grafana and Prometheus**.

📖 **Further Reading:**
- [ClickHouse Documentation](https://clickhouse.com/docs/en/)
- [Kafka Engine in ClickHouse](https://clickhouse.com/docs/en/engines/table-engines/integrations/kafka)
- [Debezium Kafka Integration](https://debezium.io/documentation/reference/3.1/tutorial.html)

