# CDC System JSON Book

---
## Source Connectors
1. Connect to Mysql Server.
```sql
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'root';
FLUSH PRIVILEGES;
```
2. Create `USER` table and `DEMO` table in `testdb`.
```sql
CREATE TABLE USER (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(150)
);
```
```sql
INSERT INTO USER (id, name, email) VALUES
(1, 'Alice Johnson', 'alice.johnson@example.com'),
(2, 'Bob Smith', 'bob.smith@example.com'),
(3, 'Charlie Davis', 'charlie.davis@example.com'),
(4, 'Diana Prince', 'diana.prince@example.com'),
(5, 'Ethan Brown', 'ethan.brown@example.com'),
(6, 'Fiona Miller', 'fiona.miller@example.com'),
(7, 'George Wilson', 'george.wilson@example.com'),
(8, 'Hannah Moore', 'hannah.moore@example.com'),
(9, 'Ian Clark', 'ian.clark@example.com'),
(10, 'Jasmine Hall', 'jasmine.hall@example.com'),
(11, 'Kevin Turner', 'kevin.turner@example.com'),
(12, 'Laura Young', 'laura.young@example.com'),
(13, 'Mike King', 'mike.king@example.com'),
(14, 'Nina Scott', 'nina.scott@example.com'),
(15, 'Oscar Adams', 'oscar.adams@example.com'),
(16, 'Paula Baker', 'paula.baker@example.com'),
(17, 'Quentin Reed', 'quentin.reed@example.com'),
(18, 'Rachel Lee', 'rachel.lee@example.com'),
(19, 'Steve Walker', 'steve.walker@example.com'),
(20, 'Tina Allen', 'tina.allen@example.com');
```

```sql
CREATE TABLE DEMO(
    id INT PRIMARY KEY,
    name VARCHAR(100)
);
```
```sql
INSERT INTO DEMO (id, name) VALUES
(1, 'Alpha'),
(2, 'Bravo'),
(3, 'Charlie'),
(4, 'Delta'),
(5, 'Echo'),
(6, 'Foxtrot'),
(7, 'Golf'),
(8, 'Hotel'),
(9, 'India'),
(10, 'Juliet'),
(11, 'Kilo'),
(12, 'Lima'),
(13, 'Mike'),
(14, 'November'),
(15, 'Oscar'),
(16, 'Papa'),
(17, 'Quebec'),
(18, 'Romeo'),
(19, 'Sierra'),
(20, 'Tango');
```

### New Source Connector (Debezium MySQL + Apicurio Avro)

To Create Connector
```bash
POST http://localhost:8083/connectors/
```

```json
{
  "name": "mysql-connector",
  "config": {
    "connector.class": "io.debezium.connector.mysql.MySqlConnector",
    "tasks.max": "1",

    "database.hostname": "host.docker.internal",
    "database.port": "3307",
    "database.user": "root",
    "database.password": "root",
    "database.server.id": "223344",
    "database.server.name": "mysql_testdb_server",
    "database.include.list": "testdb",
    "table.include.list": "testdb.user,testdb.demo",
    "database.connection.url": "jdbc:mysql://host.docker.internal:3307/testdb?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC",

    "database.allowPublicKeyRetrieval": "true",
    "snapshot.mode": "initial",
    "snapshot.locking.mode": "none",
    "snapshot.delay.ms": "10000",
    "include.schema.changes": "true",
    "include.schema.comments": "true",
    "provide.transaction.metadata": "true",
    "skipped.operations": "none",

    "max.poll.records": "20000",
    "max.batch.size": "10000",
    "max.queue.size": "20000",
    "poll.interval.ms": "50",

    "topic.prefix": "mysql_testdb_server",
    "database.history.kafka.bootstrap.servers": "kafka:9092",
    "database.history.kafka.topic": "mysql_testdb_server.schema-changes",

    "schema.history.internal": "io.debezium.storage.kafka.history.KafkaSchemaHistory",
    "schema.history.internal.kafka.bootstrap.servers": "kafka:9092",
    "schema.history.internal.kafka.topic": "mysql_testdb_server.schemahistory",
    "schema.history.internal.skip.unparseable.ddl": "true",
    "schema.history.internal.store.only.captured.tables.ddl": "true",

    "key.converter": "io.apicurio.registry.utils.converter.AvroConverter",
    "value.converter": "io.apicurio.registry.utils.converter.AvroConverter",
    "key.converter.apicurio.registry.url": "http://schemaregistry:8080/apis/registry/v2",
    "value.converter.apicurio.registry.url": "http://schemaregistry:8080/apis/registry/v2",
    "key.converter.apicurio.registry.auto-register": "true",
    "value.converter.apicurio.registry.auto-register": "true",

    "topic.creation.default.replication.factor": "1",
    "topic.creation.default.partitions": "6"
  }
}
```

### Old Source Connector (Basic JSON Setup)
```json
{
  "name": "mysql-connector",
  "config": {
    "connector.class": "io.debezium.connector.mysql.MySqlConnector",
    "tasks.max": "1",
    "database.hostname": "host.docker.internal",
    "database.port": "3307",
    "database.user": "root",
    "database.password": "root",
    "database.server.id": "223344",
    "database.server.name": "mysql_testdb_server",
    "database.include.list": "testdb",
    "table.include.list": "testdb.user,testdb.demo",
    "database.history.kafka.bootstrap.servers": "kafka:9092",
    "database.history.kafka.topic": "mysql_testdb_server.schema-changes",
    "database.connection.url": "jdbc:mysql://host.docker.internal:3307/testdb?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC",
    "database.history.skip.unreachable.databases": "true",
    "snapshot.locking.mode": "none"
  }
}
```
---

## 📤 Sink Connectors

1. Connect to Clickhouse Server
2. Create `cdc_sink` database if not exists.
3. Create table `mysql_testdb_server.testdb.user` and `mysql_testdb_server.testdb.demo`.
```sql
 CREATE TABLE `mysql_testdb_server.testdb.user` (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(150)
)
ENGINE = MERGETREE()
ORDER BY(id);
```
```sql
CREATE TABLE `mysql_testdb_server.testdb.demo` (
    id INT PRIMARY KEY,
    name VARCHAR(100)
)
ENGINE = MERGETREE()
ORDER BY(id);
```

### New Sink Connector (Altinity ClickHouse Sink Connector + Avro)

To Create Connector 
```bash
POST http://localhost:8083/connectors/
```

```json
{
  "name": "clickhouse-sink-connector",
  "config": {
    "connector.class": "com.altinity.clickhouse.sink.connector.ClickHouseSinkConnector",
    "tasks.max": "2",

    "topics": "mysql_testdb_server.testdb.user,mysql_testdb_server.testdb.demo",

    "clickhouse.server.url": "clickhouse",
    "clickhouse.server.user": "root",
    "clickhouse.server.password": "",
    "clickhouse.server.port": "8123",

    "key.converter": "io.apicurio.registry.utils.converter.AvroConverter",
    "value.converter": "io.apicurio.registry.utils.converter.AvroConverter",
    "key.converter.apicurio.registry.url": "http://schemaregistry:8080/apis/registry/v2",
    "value.converter.apicurio.registry.url": "http://schemaregistry:8080/apis/registry/v2",
    "key.converter.apicurio.registry.auto-register": "true",
    "value.converter.apicurio.registry.auto-register": "true",

    "auto.create.tables": "true",
    "auto.create.tables.replicated": "true",
    "schema.evolution": "false",

    "store.kafka.metadata": "true",
    "store.raw.data": "false",
    "store.raw.data.column": "raw_data",

    "topic.creation.default.partitions": "6",

    "metrics.enable": "true",
    "metrics.port": "8084",
    "buffer.flush.time.ms": "500",
    "thread.pool.size": "1",
    "fetch.min.bytes": "52428800",

    "enable.kafka.offset": "false",
    "replacingmergetree.delete.column": "_sign",

    "deduplication.policy": "off",
    "metadata.max.age.ms": "10000",
    "connection.pool.disable": "true"
  }
}
```

### 🕹 Old Sink Connector (ClickHouse Native Sink + JSONConverter)
```json
{
  "name": "clickhouse-sink-connector",
  "config": {
    "connector.class": "com.clickhouse.kafka.connect.ClickHouseSinkConnector",
    "tasks.max": "1",

    "topics": "mysql_testdb_server.testdb.user,mysql_testdb_server.testdb.demo",

    "hostname": "clickhouse",
    "port": "8123",
    "database": "cdc_sink",
    "username": "default",
    "password": "",
    "batch.size": "20000",
    "linger.ms": "200",

    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter.schemas.enable": "true",

    "transforms": "unwrap",
    "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
    "transforms.unwrap.drop.tombstones": "true",
    "transforms.unwrap.delete.handling.mode": "drop",

    "errors.tolerance": "all",
    "errors.log.enable": "true"
  }
}
```
---
## Debezium Connector REST API Guide

### Get Available Connector Plugins
Use this to list all available plugins in your Debezium Connect worker.

```bash
GET http://localhost:8083/connector-plugins
```

**Expected Output**
```json
[
  {
    "class": "com.altinity.clickhouse.sink.connector.ClickHouseSinkConnector",
    "type": "sink",
    "version": "0.0.1"
  },
  {
    "class": "com.clickhouse.kafka.connect.ClickHouseSinkConnector",
    "type": "sink",
    "version": "v1.2.6"
  },
  {
    "class": "io.debezium.connector.jdbc.JdbcSinkConnector",
    "type": "sink",
    "version": "2.4.0.Final"
  },
  {
    "class": "io.debezium.connector.mysql.MySqlConnector",
    "type": "source",
    "version": "2.4.0.Final"
  }
  ...
]
```

---

### Get Configured Connectors
Lists all configured connectors currently running on the Kafka Connect instance.

```bash
GET http://localhost:8083/connectors
```

**Expected Output**
```json
[
  "clickhouse-sink-connector",
  "mysql-connector"
]
```

---

### Get Connector Status

#### Source Connector Status
```bash
GET http://localhost:8083/connectors/mysql-connector/status
```

**Expected Output**
```json
{
  "name": "mysql-connector",
  "connector": {
    "state": "RUNNING",
    "worker_id": "172.18.0.8:8083"
  },
  "tasks": [
    {
      "id": 0,
      "state": "RUNNING",
      "worker_id": "172.18.0.8:8083"
    }
  ],
  "type": "source"
}
```

#### Sink Connector Status
```bash
GET http://localhost:8083/connectors/clickhouse-sink-connector/status
```

**Expected Output**
```json
{
  "name": "clickhouse-sink-connector",
  "connector": {
    "state": "RUNNING",
    "worker_id": "172.18.0.8:8083"
  },
  "tasks": [
    {
      "id": 0,
      "state": "RUNNING",
      "worker_id": "172.18.0.8:8083"
    },
    {
      "id": 1,
      "state": "RUNNING",
      "worker_id": "172.18.0.8:8083"
    }
  ],
  "type": "sink"
}
```

---

### Restart Connectors

#### Restart Source Connector
```bash
POST http://localhost:8083/connectors/mysql-connector/restart
```
**Expected Output:** `HTTP 204 No Content`

#### Restart Sink Connector
```bash
POST http://localhost:8083/connectors/clickhouse-sink-connector/restart
```
**Expected Output:** `HTTP 204 No Content`

---

### Delete Connectors

#### Delete Source Connector
```bash
DELETE http://localhost:8083/connectors/mysql-connector
```
**Expected Output:** `HTTP 204 No Content`

#### Delete Sink Connector
```bash
DELETE http://localhost:8083/connectors/clickhouse-sink-connector
```
**Expected Output:** `HTTP 204 No Content`

---
## **Port Definitions**

| **Service**         | **Port(s)**          |
|---------------------|----------------------|
| **MySQL-CDC**        | `3307`               |
| **ClickHouse**       | `8123`               |
| **Zookeeper**        | `2181`               |
| **Kafka**            | `7071`, `9092`       |
| **Kafka UI**         | `8081`               |
| **Schema Registry**  | `8080`               |
| **Debezium**         | `8083`               |
| **Debezium UI**      | `8084`               |

---

### Currenctly using `docker-compose-debeizum.yml` file 

```yml
version: '3.8'

services:
  connect:
    image: debezium/connect:2.4.0.Final
    container_name: debezium
    ports:
      - 8083:8083
    volumes:
      - ./debezium-plugins:/kafka/connect/custom-plugins
    depends_on:
      - kafka
      - schemaregistry
    environment:
      BOOTSTRAP_SERVERS: kafka:9092
      GROUP_ID: 1
      CONFIG_STORAGE_TOPIC: my_connect_configs
      OFFSET_STORAGE_TOPIC: my_connect_offsets
      STATUS_STORAGE_TOPIC: my_connect_statuses
      CONNECT_PLUGIN_PATH: /kafka/connect,/kafka/connect/custom-plugins

      # Enable Apicurio converters
      ENABLE_APICURIO_CONVERTERS: "true"

      # Key converter
      CONNECT_KEY_CONVERTER: io.apicurio.registry.utils.converter.AvroConverter
      CONNECT_KEY_CONVERTER_APICURIO.REGISTRY_URL: http://schemaregistry:8080/apis/registry/v2
      CONNECT_KEY_CONVERTER_APICURIO.REGISTRY_AUTO-REGISTER: "true"
      CONNECT_KEY_CONVERTER_APICURIO_REGISTRY_FIND-LATEST: "true"

      # Value converter
      CONNECT_VALUE_CONVERTER: io.apicurio.registry.utils.converter.AvroConverter
      CONNECT_VALUE_CONVERTER_APICURIO.REGISTRY_URL: http://schemaregistry:8080/apis/registry/v2
      CONNECT_VALUE_CONVERTER_APICURIO_REGISTRY_AUTO-REGISTER: "true"
      CONNECT_VALUE_CONVERTER_APICURIO_REGISTRY_FIND-LATEST: "true"

      # Optional: Prometheus JMX metrics
#      KAFKA_OPTS: -javaagent:/kafka/etc/jmx_prometheus_javaagent.jar=1976:/kafka/etc/config.yml
#      JMXHOST: localhost
#      JMXPORT: 1976

    networks:
      - cdc-network

  debezium-ui:
    image: debezium/debezium-ui:1.9.0.Final
    container_name: debezium-ui
    ports:
      - 8084:8080
    depends_on:
      - connect
    environment:
      KAFKA_CONNECT_URIS: http://debezium:8083
    networks:
      - cdc-network

  schemaregistry:
    container_name: schemaregistry
    image: apicurio/apicurio-registry-mem:latest-release
    restart: "no"
    ports:
      - "8080:8080"
    environment:
      - KAFKA_BOOTSTRAP_SERVERS=kafka:9092
    depends_on:
      - kafka
    networks:
      - cdc-network

networks:
  cdc-network:
    external: true
```

