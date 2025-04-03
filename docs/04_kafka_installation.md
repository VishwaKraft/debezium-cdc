# Kafka Installation Guide

## Installation Methods

### 1. Using Docker Compose (Recommended)
The easiest way to set up Apache Kafka is by using Docker Compose. Below is a **Docker Compose configuration** that sets up Kafka with ZooKeeper:

#### Step 1: Create a `docker-compose.yml` file

```yaml
version: '3.7'
services:
  zookeeper:
    image: confluentinc/cp-zookeeper:latest
    container_name: zookeeper
    restart: unless-stopped
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
    ports:
      - "2181:2181"

  kafka:
    image: confluentinc/cp-kafka:latest
    container_name: kafka
    restart: unless-stopped
    depends_on:
      - zookeeper
    ports:
      - "9092:9092"
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: "zookeeper:2181"
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://localhost:9092
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
```

#### Step 2: Start Kafka
Run the following command in the same directory where `docker-compose.yml` is located:

```sh
docker-compose up -d
```

#### Step 3: Verify Kafka is Running
To check the logs and confirm that Kafka has started successfully:

```sh
docker logs -f kafka
```

**Reference:** [Confluent Kafka Docker Documentation](https://docs.confluent.io/platform/current/installation/docker.html)

### 2. Installing Kafka Manually (Without Docker)

#### Step 1: Download Apache Kafka
```sh
wget https://downloads.apache.org/kafka/3.5.1/kafka_2.13-3.5.1.tgz
```

#### Step 2: Extract Kafka
```sh
tar -xvzf kafka_2.13-3.5.1.tgz
cd kafka_2.13-3.5.1
```

#### Step 3: Start ZooKeeper
```sh
bin/zookeeper-server-start.sh config/zookeeper.properties
```

#### Step 4: Start Kafka Server
```sh
bin/kafka-server-start.sh config/server.properties
```

**Reference:** [Apache Kafka Quick Start](https://kafka.apache.org/quickstart)

### 3. Installing Kafka via Package Managers

#### **On Ubuntu (Using APT)**
```sh
sudo apt update && sudo apt install kafka
```

#### **On macOS (Using Homebrew)**
```sh
brew install kafka
```

### 4. Running Kafka in Kubernetes
If you need Kafka on Kubernetes, you can deploy it using Helm:
```sh
helm repo add confluentinc https://packages.confluent.io/helm
helm install my-kafka confluentinc/cp-helm-charts
```

**Reference:** [Confluent Helm Charts](https://docs.confluent.io/operator/current/co-deployment.html)

---

## Understanding Kafka

### What is Apache Kafka?
Kafka is a **distributed event streaming platform** designed for high-throughput, fault-tolerant data pipelines, event-driven architectures, and real-time analytics.

### Why Use Kafka?
- **Scalability:** Handles high volumes of data efficiently.
- **Fault Tolerance:** Replicates data across multiple nodes.
- **Real-Time Streaming:** Processes data in real-time for instant insights.
- **Decoupled Architecture:** Allows services to communicate asynchronously without tight coupling.
- **Guaranteed Message Delivery:** Provides durability through log-based storage and replication.

**Reference:** [Kafka Documentation](https://kafka.apache.org/documentation/)

### Kafka Topics
Kafka stores messages in **topics**, which are:
- **Partitioned** for scalability.
- **Replicated** for fault tolerance.

**Partitions** allow Kafka to parallelize message processing across multiple consumers.

### Kafka Producers & Consumers
- **Producers** send messages to Kafka topics asynchronously.
- **Consumers** read messages from Kafka topics at their own pace, supporting both real-time and batch processing.

### What is ZooKeeper & Its Role in Kafka?
ZooKeeper helps Kafka manage:
- **Leader election** for partitioned topics.
- **Configuration management** for brokers.
- **Health monitoring** of Kafka nodes.

**Kafka Without ZooKeeper (KRaft Mode):**
- Kafka 3.x introduces KRaft (Kafka Raft) mode, removing the need for ZooKeeper and improving scalability.

**Reference:** [ZooKeeper Overview](https://zookeeper.apache.org/doc/current/zookeeperOver.html)

## Why We Use Kafka in Real-Time Sync with Debezium CDC, MySQL, and ClickHouse

### Role of Kafka in Real-Time Data Streaming
Kafka serves as the central event streaming platform in our architecture. It plays a crucial role in **capturing, processing, and delivering** real-time change data from MySQL to ClickHouse using Debezium CDC.

### How Kafka Works in This Architecture
1. **Debezium Captures Changes from MySQL:**
    - Debezium listens to MySQL binlog changes and produces **CDC events**.
    - These events (INSERT, UPDATE, DELETE) are published to Kafka topics.

2. **Kafka Acts as an Event Hub:**
    - Kafka decouples the source (MySQL) from the sink (ClickHouse), ensuring reliable data streaming.
    - Kafka provides **durability, fault tolerance, and scalability** for processing CDC events.
    - Multiple consumers can process the same events in different ways (analytics, monitoring, etc.).

3. **ClickHouse Consumes Kafka Topics:**
    - ClickHouse reads the Kafka topics using **Kafka engine tables**.
    - It processes and stores data efficiently for **real-time analytics**.

### Why Kafka is Essential for This Pipeline
- **Scalability:** Kafka efficiently handles large-scale data changes.
- **Fault Tolerance:** Messages remain in Kafka even if ClickHouse is temporarily unavailable.
- **Event Replay:** Kafka allows reprocessing past CDC events if needed.
- **Decoupled Processing:** MySQL changes can be processed independently by multiple services (analytics, logging, monitoring, etc.).
- **High Throughput:** Kafka ensures high-speed data ingestion and delivery.

**Reference:** [Debezium Kafka Integration](https://debezium.io/documentation/reference/3.1/tutorial.html)

---

### Additional Considerations
- **Security:** Set up authentication & authorization via SSL, SASL, and ACLs.
- **Monitoring:** Use tools like Prometheus, Grafana, or Confluent Control Center.
- **Retention Policies:** Configure log retention for optimized storage.
- **Replication Factors:** Ensure high availability by setting replication factors appropriately.

---

## Next Steps
- Set up **Kafka Connect** to integrate with external systems.
- Configure **Debezium** to use Kafka for real-time data streaming.
- Tune Kafka performance for production use.

**Further Reading:**
- [Kafka Streams](https://kafka.apache.org/documentation/streams/)
- [Kafka Connect](https://docs.confluent.io/platform/current/connect/index.html)
- [Kafka Security](https://docs.confluent.io/platform/current/kafka/security-overview.html)

