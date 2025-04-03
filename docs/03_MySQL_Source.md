# MySQL as a Source for Debezium CDC

## Overview

The **Debezium MySQL Connector** is a key component in Change Data Capture (CDC) pipelines, enabling real-time streaming of MySQL database changes to Apache Kafka. It reads MySQL's binary logs (binlogs) to capture inserts, updates, and deletes, making it essential for event-driven architectures and real-time analytics.

## How MySQL Acts as a Source in CDC Pipelines

MySQL acts as a source database for Debezium by leveraging its binary logging mechanism to track all changes made to tables. The Debezium MySQL Connector captures these changes and streams them into Kafka topics. This enables real-time data synchronization, event-driven workflows, and analytics use cases.

Debezium integrates with MySQL as a source by:

- Connecting to the MySQL server and monitoring its binlogs.
- Capturing row-level changes in real-time and streaming them to Kafka topics.
- Providing an immutable stream of change events, preserving the order of transactions.

## Installation Process (Docker-Based)

### 1. Single Command Approach:
```sh
docker run -d --name mysql-cdc -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=testdb -p 3306:3306 --restart unless-stopped mysql:8.0 --server-id=1 --log-bin=mysql-bin --binlog-format=ROW --binlog-row-image=FULL
```  
This is the same as your original command but condensed into a single line.

---

### 2. Docker Compose Method:
Alternatively, you can use `docker-compose` to manage MySQL:  

1. **Create a `docker-compose.yml` file:**  

```yaml
version: '3.8'
services:
  mysql:
    image: mysql:8.0
    container_name: mysql-cdc
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: testdb
    ports:
      - "3306:3306"
    command: >
      --server-id=1
      --log-bin=mysql-bin
      --binlog-format=ROW
      --binlog-row-image=FULL
```

2. **Run the following command to start MySQL:**  
```sh
docker-compose up -d
```

This method makes it easier to manage, modify, and scale the setup. Let me know if you need any refinements! 🚀

### 3. Create a Debezium User in MySQL

Connect to the MySQL instance:

```sh
docker exec -it mysql-cdc mysql -uroot -proot
```

Then run the following SQL commands to create a user for Debezium with the necessary privileges:

```sql
CREATE USER 'debezium'@'%' IDENTIFIED BY 'dbz';
GRANT SELECT, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'debezium'@'%';
FLUSH PRIVILEGES;
```

Exit MySQL:
```sh
exit
```

## Performance Considerations

- **Disk Space Management**: Large binlogs can impact storage. Tune retention settings appropriately.
- **Replication & Failover**: If using MySQL replication, ensure Debezium reads from a replica to reduce load on the primary.
- **Kafka Partitioning**: Ensure proper partitioning strategy to handle large data streams efficiently.

## Connector Configuration

### Essential Configuration Options
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
    "database.server.name": "dbserver1",
    "database.include.list": "inventory",
    "database.history.kafka.bootstrap.servers": "kafka:9092",
    "database.history.kafka.topic": "schema-changes.inventory"
  }
}
```

## Transaction Logs in MySQL

### MySQL Binlogs

- MySQL uses **binary logs (binlogs)** to record all changes to database tables.
- Binlogs capture events in a sequential manner, enabling replication and CDC.
- Debezium reads binlogs and converts changes into Kafka events.

## Checking and Enabling Binlogs in MySQL

### Checking Binlog Status

To check if binlogs are enabled, run:

```sh
docker exec -it mysql-cdc mysql -uroot -proot -e "SHOW VARIABLES LIKE 'log_bin';"
```

If `log_bin` is set to `ON`, binlogs are enabled.

### Enabling Binlogs

If binlogs are not enabled, restart the MySQL container with the correct configuration as mentioned in the installation section.

## MySQL Binary Log Configuration

### Verifying Binlog Status
```sql
SHOW VARIABLES LIKE 'log_bin';
SHOW VARIABLES LIKE 'binlog_format';
SHOW VARIABLES LIKE 'binlog_row_image';
```

## Next Steps

After configuring MySQL as a source, proceed with setting up Kafka and Debezium Connector to start streaming data. 
For further details, refer to the [Debezium MySQL Connector Documentation](https://debezium.io/documentation/reference/3.1/connectors/mysql.html#debezium-connector-for-mysql).

