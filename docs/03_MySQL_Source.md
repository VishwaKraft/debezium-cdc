# MySQL as a Source in CDC using Debezium, MySQL, and Kafka

## Overview
Change Data Capture (CDC) using **Debezium**, **MySQL**, and **Kafka** enables real-time data synchronization by capturing changes in a MySQL database and streaming them into Kafka topics. This guide provides step-by-step instructions on setting up this pipeline.

## Prerequisites
Ensure you have the following installed:
- **Docker & Docker Compose**
- **Kafka** (via Docker)
- **Debezium MySQL Connector**
- **MySQL Database**
- **Kafka Connect**

## Step 1: Setup MySQL Database

Start a MySQL instance using Docker:

```yaml
version: '3.7'
services:
  mysql:
    image: mysql:8.0
    container_name: mysql-cdc
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: testdb
    ports:
      - "3306:3306"
    command: --default-authentication-plugin=mysql_native_password
    volumes:
      - mysql_data:/var/lib/mysql

volumes:
  mysql_data:
```

### Configure MySQL for CDC

1. Enter the MySQL container:
   ```sh
   docker exec -it mysql-cdc mysql -uroot -proot
   ```
2. Enable binary logging and set up a user for Debezium:
   ```sql
   ALTER USER 'root'@'%' IDENTIFIED WITH 'mysql_native_password' BY 'root';
   FLUSH PRIVILEGES;
   
   CREATE USER 'debezium'@'%' IDENTIFIED WITH 'mysql_native_password' BY 'dbz';
   GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'debezium'@'%';
   FLUSH PRIVILEGES;
   ```

## Step 2: Setup Kafka and Debezium

Use the following Docker Compose file to set up Kafka, Zookeeper, and Kafka Connect with Debezium:

```yaml
version: '3.7'
services:
  zookeeper:
    image: confluentinc/cp-zookeeper:latest
    container_name: zookeeper
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181

  kafka:
    image: confluentinc/cp-kafka:latest
    container_name: kafka
    depends_on:
      - zookeeper
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka:9092
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
    ports:
      - "9092:9092"

  kafka-connect:
    image: debezium/connect:latest
    container_name: kafka-connect
    depends_on:
      - kafka
    environment:
      BOOTSTRAP_SERVERS: kafka:9092
      GROUP_ID: "1"
      CONFIG_STORAGE_TOPIC: my_connect_configs
      OFFSET_STORAGE_TOPIC: my_connect_offsets
      STATUS_STORAGE_TOPIC: my_connect_status
    ports:
      - "8083:8083"
```

## Step 3: Register MySQL as a Debezium Source Connector

Use the following JSON configuration to register the MySQL connector with Kafka Connect:

```json
{
  "name": "mysql-connector",
  "config": {
    "connector.class": "io.debezium.connector.mysql.MySqlConnector",
    "database.hostname": "mysql",
    "database.port": "3306",
    "database.user": "debezium",
    "database.password": "dbz",
    "database.server.id": "1",
    "database.include.list": "testdb",
    "database.history.kafka.bootstrap.servers": "kafka:9092",
    "database.history.kafka.topic": "schema-changes.testdb"
  }
}
```

### Deploy the Connector

Run the following command to deploy the connector:
```sh
curl -X POST -H "Content-Type: application/json" --data @mysql-connector.json http://localhost:8083/connectors
```

## Step 4: Verify Data Streaming

### Create a Test Table in MySQL
```sql
USE testdb;
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    department VARCHAR(100)
);
INSERT INTO employees (name, department) VALUES ('John Doe', 'Engineering');
```

### Consume Kafka Messages
Start a Kafka consumer to verify data streaming:
```sh
docker exec -it kafka kafka-console-consumer --bootstrap-server kafka:9092 --topic testdb.employees --from-beginning
```

---

### **Different types of transaction logs used by various databases and how they work.**

| **Database**      | **Transaction Log Type** | **Description** |
|-------------------|------------------------|----------------|
| **MySQL**        | **Binary Log (Binlog)** | Records all changes (INSERT, UPDATE, DELETE) at the row level or statement level. Used for replication and CDC. |
| **PostgreSQL**   | **Write-Ahead Log (WAL)** | Logs all changes before applying them to the actual database. Used for recovery and CDC. |
| **SQL Server**   | **Transaction Log (T-Log)** | Stores all changes and ensures ACID compliance. Used for backup, replication, and CDC. |
| **Oracle**       | **Redo Log** | Captures all database changes and helps recover data after a crash. Used for replication and CDC. |
| **MongoDB**      | **Oplog (Operation Log)** | A capped collection that records all operations for replication. Used for CDC in distributed setups. |
| **Cassandra**    | **Commit Log** | A write-ahead log that ensures data durability before changes are written to SSTables. |
| **DB2**          | **DB2 Logs** | Contains all transactional changes and is used for rollback and CDC. |

Each of these logs allows **Debezium** (or similar CDC tools) to capture changes and stream them to **Kafka** or other systems.

## Troubleshooting
### 1. Verify Kafka Connect Logs
If the connector fails to start, check logs:
```sh
docker logs debezium
```

### 2. Ensure MySQL Binlog is Enabled
Check if binary logging is enabled:
```sql
SHOW VARIABLES LIKE 'log_bin';
```

### 3. Verify Kafka Topics
Ensure Kafka is receiving CDC events:
```sh
kafka-topics --list --bootstrap-server localhost:9092
```

## Conclusion
Using Debezium, MySQL, and Kafka, you can capture and stream real-time changes to external systems. This setup ensures reliable and efficient CDC, enabling real-time data synchronization for various use cases, including integration with ClickHouse for real-time analytics.
