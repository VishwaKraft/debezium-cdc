# CDC System Load Testing Strategies

This document outlines different load testing strategies for a Change Data Capture (CDC) system using:
- **MySQL** (source)
- **Debezium** (CDC connector)
- **Kafka** (message broker)
- **ClickHouse** (sink/analytics DB)

## Goals of Load Testing

- Evaluate system throughput and latency.
- Identify bottlenecks (MySQL, Kafka, Debezium, ClickHouse).
- Determine maximum sustainable load.
- Understand resource usage (CPU, Memory, Disk, I/O).
- Verify end-to-end replication under stress.

---

## 1.**Change Event Ingestion Load Test (MySQL)**

**Tool:** [Apache JMeter](https://jmeter.apache.org/) or custom script (e.g., Python or Go).

### Objective:
Simulate high volume of `INSERT`, `UPDATE`, `DELETE` statements on MySQL tables.

### Strategy:
- Create large datasets (bulk load).
- Run concurrent transactions using multiple threads.
- Measure:
  - Transactions per second (TPS)
  - Binlog generation rate
  - Debezium CDC pick-up delay

### Metrics to Observe:
- MySQL binlog size growth
- CPU and disk I/O on MySQL
- Debezium lag (in Kafka Connect UI or JMX metrics)

---

## 2.**Kafka Throughput and Lag Test**

**Tool:** Kafka producer/consumer clients, [Kafka Load Generator](https://github.com/linkedin/kafka-tools).
### Objective:
Assess how Kafka handles incoming CDC messages.

### Strategy:
- Produce mock Debezium-like messages directly (or indirectly via MySQL).
- Monitor:
  - Kafka broker throughput (MB/sec)
  - Topic partitions and consumer lag
  - Message retention and disk usage

### Metrics to Observe:
- Consumer group lag (`kafka.consumer:type=consumer-fetch-manager-metrics`)
- Broker I/O, disk usage, and heap memory
- Partition skew and replication delays

---

## 3.**Debezium Connector Load Test**

**Tool:** JMeter (DB writes), Debezium UI, Kafka Connect REST API

### Objective:
Test how Debezium performs under high binlog update frequency.

### Strategy:
- Perform rapid `INSERT`/`UPDATE`/`DELETE` operations in MySQL.
- Monitor Debezium metrics:
  - `source-records-poll-rate`
  - `source-records-poll-total`
  - Connector lag (`source-lag-ms`)
- Stress Kafka Connect worker node (CPU, GC, thread pool)

### Metrics to Observe:
- Kafka Connect worker memory & CPU usage
- Task-level metrics (poll rate, commit rate)
- JMX: `kafka.connect:type=connect-worker-metrics`

---

## 4. **ClickHouse Sink Load Test**

**Tool:** Produce Kafka messages manually or from MySQL via Debezium

### Objective:
Validate how well ClickHouse consumes and ingests data from Kafka via the Sink Connector.

### Strategy:
- Use `com.clickhouse.kafka.connect.ClickHouseSinkConnector`.
- Simulate different ingestion batch sizes.
- Test partition rebalancing & retries.
- Tune:
  - `insert.batch.size`
  - `topics`
  - `consumer.poll.interval.ms`

### Metrics to Observe:
- Ingestion throughput (rows/sec)
- Insert errors or timeouts
- CPU and disk on ClickHouse node
- Query performance post ingestion

---

## 5.**End-to-End Latency Test**

### Objective:
Measure time taken from MySQL write → Debezium → Kafka → ClickHouse

### Strategy:
- Timestamp inserted rows in MySQL
- Capture timestamps at Kafka and ClickHouse
- Calculate lag at each stage

### Tools:
- Debezium log parsing
- Kafka consumer log timestamps
- ClickHouse table with ingestion timestamps

### Latency Breakdown:
| Stage            | Metric                         |
|------------------|--------------------------------|
| MySQL → Debezium | Binlog delay                   |
| Debezium → Kafka | Connector processing lag       |
| Kafka → ClickHouse | Sink connector commit interval |

---

## 6. **Failure and Recovery Scenarios**

### Objective:
Test system resilience and data consistency under failure conditions.

### Strategy:
- Kill/restart Debezium, Kafka brokers, or ClickHouse.
- Simulate network latency or disk pressure.
- Observe data loss, duplication, or recovery time.

### Checks:
- Is CDC resumed gracefully?
- Is data replayed without duplication?
- Are Kafka offsets managed correctly?

---

## 7. **Monitoring and Observability**

Ensure the following tools are running for real-time observability:

- **Prometheus + Grafana** for:
  - MySQL
  - Kafka & Zookeeper
  - Kafka Connect (Debezium)
  - ClickHouse

- **JMX Exporter** for Kafka & Connect
- **ClickHouse System Tables**: `system.parts`, `system.metrics`

---

## References

- [Debezium Monitoring Docs](https://debezium.io/documentation/reference/)
- [Kafka Performance Tuning](https://kafka.apache.org/documentation/#tuning)
- [ClickHouse Performance Guide](https://clickhouse.com/docs/en/operations/tips/)
- [JMeter MySQL Plugin](https://jmeter-plugins.org/wiki/JDBC-Request/)
