# ClickHouse Installation Guide

## What is ClickHouse?
ClickHouse is a **columnar database** designed for **high-performance analytics** and **real-time data processing**. It is optimized for OLAP (Online Analytical Processing) workloads and can process massive amounts of data efficiently.

**Reference:** [ClickHouse Official Documentation](https://clickhouse.com/docs/en/)

## Why Use ClickHouse as a Sink?
ClickHouse is widely used as a **sink** in real-time data pipelines due to:
- **High Ingestion Performance**: Handles millions of events per second.
- **Columnar Storage**: Optimized for fast analytical queries.
- **Real-Time Processing**: Processes incoming data with low latency.
- **Efficient Compression**: Reduces storage costs while maintaining high-speed reads.
- **Scalability**: Supports horizontal and vertical scaling.

**Reference:** [ClickHouse vs Traditional Databases](https://clickhouse.com/blog/why-clickhouse-is-so-fast)

## Installing ClickHouse

### 1. Using Docker Compose (Recommended)
To quickly set up ClickHouse, create a `docker-compose-clickhouse.yml` file:

Start ClickHouse using:
```bash
docker-compose -f docker-compose-clichouse.yml up
```

**Reference:** [ClickHouse Docker Setup](https://hub.docker.com/r/clickhouse/clickhouse-server)

**Reference:** [ClickHouse Installation Methods](https://clickhouse.com/docs/en/getting-started/install/)

## How ClickHouse Captures Data from Kafka and Debezium
ClickHouse can ingest data from Kafka topics **without an external connector** by using its built-in **Kafka Engine**.

### **How It Works:**
1. **Debezium Captures Changes from MySQL**
   - Debezium reads MySQL binlogs and sends **CDC events** to Kafka topics.
2. **Kafka Stores CDC Events**
   - Kafka acts as an event bus, ensuring reliability and scalability.
3. **ClickHouse Reads from Kafka Topics**
   - ClickHouse **directly reads Kafka messages** using the `Kafka Engine`.

**Reference:** [Debezium Kafka Integration](https://debezium.io/documentation/reference/3.1/tutorial.html)

## Configuring ClickHouse Kafka Integration
To integrate ClickHouse with Kafka, create a **Kafka Engine table**.

**Reference:** [ClickHouse Kafka Engine](https://clickhouse.com/docs/en/engines/table-engines/integrations/kafka)

## Kafka-ClickHouse Connector Configuration (Alternative Approach)
Alternatively, you can use **Kafka Connect** with a ClickHouse **JDBC Sink Connector**.

### **Kafka Connect Sink Configuration**
```json
{
   "name": "clickhouse-sink-connector",
   "config": {
      "connector.class": "com.vishwakraft.clickhouse.sink.connector.ClickHouseSinkConnector",
      "tasks.max": "1",
      "schemas.enable": "false",
      "connection.pool.disable": "true",
      "topics": "mysql_testdb.testdb.user",
      "clickhouse.server.url": "clickhouse",
      "clickhouse.server.user": "default",
      "clickhouse.server.password": "",
      "clickhouse.topic2table.map": "mysql_testdb.testdb.user:user",
      "clickhouse.database.override.map":"testdb:cdc_sink",
      "auto.create.tables": "true",
      "clickhouse.auto.evolve": "true"
   }
}

```

### **Deploy the Connector**
1. Start Kafka Connect with the ClickHouse Sink Connector plugin.
2. Register the connector:
```bash
POST http://localhost:8083/connectors
```
### Check status of connector
**Endpoint**
```bash
GET http://localhost:8083/connectors/clickhouse-sink-connector/status
```
**Expected output:**
```json
{
    "name": "clickhouse-sink-connector",
    "connector": {
        "state": "RUNNING",
        "worker_id": "172.19.0.7:8083"
    },
    "tasks": [
        {
            "id": 0,
            "state": "RUNNING",
            "worker_id": "172.19.0.7:8083"
        }
    ],
    "type": "sink"
}
```
### Restart Sink Connector

```bash
POST http://localhost:8083/connectors/clickhouse-sink-connector/restart
```
### Delete the Sink Connector
```bash 
DELETE http://localhost:8083/connectors/clickhouse-sink-connector
```

**Reference:** [Kafka Connect ClickHouse Sink](https://github.com/ClickHouse/clickhouse-kafka-connect)

## Why ClickHouse for CDC Pipelines?
- **Handles large-scale streaming data efficiently**.
- **High-speed ingestion with the Kafka engine**.
- **Cost-effective storage with columnar compression**.
- **Real-time analytics with optimized OLAP queries**.

**Reference:** [ClickHouse for Streaming Data](https://clickhouse.com/blog/clickhouse-and-streaming-data)

## Next Steps
- Tune ClickHouse performance for production use.
- Set up **replication and sharding** for high availability.
- Monitor ClickHouse using **Grafana and Prometheus**.

**Further Reading:**
- [ClickHouse Documentation](https://clickhouse.com/docs/en/)
- [Kafka Engine in ClickHouse](https://clickhouse.com/docs/en/engines/table-engines/integrations/kafka)
- [Debezium Kafka Integration](https://debezium.io/documentation/reference/3.1/tutorial.html)

