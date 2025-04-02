# Real-Time Data Synchronization & Event-Driven Architectures

## Problem Statement

### 1. Handling Database Changes Efficiently
When data is updated in relational databases like MySQL, downstream applications must react immediately. The main challenge is to extract and apply these changes in a simple and scalable way. Keeping database updates in sync with downstream applications is crucial to prevent data inconsistencies and performance bottlenecks.

![Database Changes](https://github.com/user-attachments/assets/fcd631b6-6a60-42d1-b331-ea3fa211af92)

### 2. Schema Evolution & Data Consistency
As databases evolve over time, schema changes can disrupt downstream applications, leading to inconsistencies. Ensuring seamless schema evolution is crucial to avoid data corruption and maintain smooth application performance.

![Schema Evolution](https://github.com/user-attachments/assets/c04363e9-d5ea-4857-b6d3-3590b23df09a)

### 3. Keeping Multiple Systems in Sync
Traditional batch processing methods introduce significant delays in data synchronization. Businesses require real-time updates across various systems, including databases, analytics platforms, and search indexes, to enable timely decision-making and enhance user experiences.

![Keeping Multiple Systems in Sync](https://github.com/user-attachments/assets/070d3264-659a-449e-940d-a920a7f569a2)

### 4. Building Event-Driven Systems
Modern applications leverage event-driven architectures for microservices communication, real-time analytics, and fraud detection. Streaming database changes as events without modifying existing applications is a key challenge.

![Building Event-Driven Systems](https://github.com/user-attachments/assets/43e2204c-28fb-4107-bc25-09db0a6e3e70)

### 5. Fault Tolerance & Scalability
Polling-based approaches that periodically query databases introduce performance bottlenecks and are not scalable. A robust solution must provide fault tolerance while efficiently capturing and processing changes.

![Fault Tolerance](https://github.com/user-attachments/assets/1dd75a3f-bbc5-4b1d-9125-8fdb8d2a6e0f)

## Solution: Debezium for Change Data Capture (CDC)
Debezium is an open-source distributed platform that captures database changes in real-time and streams them to other systems like Kafka. By leveraging Debezium, we can efficiently propagate changes without modifying existing applications.

### Architecture Overview
For a detailed explanation of the architecture, refer to [Architecture.md](https://github.com/Datavolt/debezium-cdc/blob/main/docs/Architecture.md).

### Components
1. **MySQL as the Source Database**
   - Captures change events using MySQL binlog.
   - Configured as a Debezium source.
   - Refer to the setup guide: [MySQL_Source.md](https://github.com/Datavolt/debezium-cdc/blob/main/docs/MySQL_Source.md)

2. **Kafka as the Event Streaming Platform**
   - Acts as a message broker for change events.
   - Provides durable storage and event replay capabilities.

3. **ClickHouse as the Sink Database**
   - Consumes events from Kafka and applies changes.
   - Optimized for fast analytics and real-time queries.
   - Refer to the setup guide: [ClickHouse_Sink.md](https://github.com/Datavolt/debezium-cdc/blob/main/docs/Clickhouse_Sink.md)

## Setting Up the Real-Time Sync System
### Prerequisites
- Docker and Docker Compose installed
- Kafka and Zookeeper running
- MySQL with binlog enabled
- ClickHouse for real-time analytics

### Steps to Deploy
1. **Start Kafka & Zookeeper:**
   ```bash
   docker-compose up -d kafka zookeeper
   ```
2. **Configure MySQL as Debezium Source:** (Refer to [MySQL Source Documentation](https://github.com/Datavolt/debezium-cdc/blob/main/docs/MySQL_Source.md))
3. **Deploy Debezium Connector:**
   ```bash
   curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" \
       --data '{"name": "inventory-connector", "config": { ... }}' \
       http://localhost:8083/connectors
   ```
4. **Configure ClickHouse Sink:** (Refer to [ClickHouse Sink Documentation](https://github.com/Datavolt/debezium-cdc/blob/main/docs/Clickhouse_Sink.md))
5. **Monitor Data Flow in Kafka Topics:**
   ```bash
   kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic dbserver1.inventory.customers --from-beginning
   ```

## Conclusion
Using Debezium, Kafka, and ClickHouse, we can build a real-time, event-driven data synchronization system that ensures consistency, scalability, and fault tolerance. This architecture enables seamless database change propagation without performance bottlenecks, allowing businesses to leverage real-time analytics and event-driven processing.

