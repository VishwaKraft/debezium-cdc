# Real-Time Data Synchronization - Installation Guide

## Overview
This guide provides step-by-step instructions for setting up a real-time data synchronization system using Debezium CDC, MySQL as the source database, Kafka as the streaming platform, and ClickHouse as the sink. The installation process is divided into multiple sections for better organization and ease of implementation.

By following this guide, you will be able to:
- Set up MySQL as the source database with Change Data Capture (CDC) enabled.
- Install and configure Kafka for real-time event streaming.
- Deploy Debezium as a Kafka Connect source to capture changes from MySQL.
- Configure ClickHouse as a sink to store and process streaming data efficiently.

## Prerequisites
Before you begin, ensure that you meet the following requirements:

- **Docker and Docker Compose** (if using containerized deployment).
- **MySQL 8.0+** with binary logging enabled.
- **Apache Kafka** (latest stable version) installed and configured.
- **ClickHouse** installed and running.
- **Kafka Connect with Debezium MySQL connector**.
- **Appropriate user permissions** in MySQL for Debezium to read binlogs.

## Installation Steps
To set up the complete system, follow these individual installation guides:

1. **MySQL as Source**  
   - Setup MySQL database and configure it for Debezium CDC.
   - Enable binlog and configure necessary settings.
   - [Read MySQL Source Installation Guide](https://github.com/Datavolt/debezium-cdc/blob/main/docs/03_MySQL_Source.md)

2. **Kafka Installation**  
   - Install and configure Kafka for event streaming.
   - Setup Zookeeper and Kafka brokers.
   - [Read Kafka Installation Guide](https://github.com/Datavolt/debezium-cdc/blob/main/docs/04_kafka_installation.md)

3. **Debezium Installation**  
   - Install Debezium and configure it as a Kafka Connect source.
   - Setup Debezium connectors for MySQL.
   - [Read Debezium Installation Guide](https://github.com/Datavolt/debezium-cdc/blob/main/docs/06_debezium_installation.md)

4. **ClickHouse as Sink**  
   - Install ClickHouse and configure it to consume Kafka topics.
   - Setup ClickHouse Kafka engine for data ingestion.
   - [Read ClickHouse Sink Installation Guide](https://github.com/Datavolt/debezium-cdc/blob/main/docs/05_Clickhouse_Sink.md)
   - 
## Conclusion
Once you have completed the installation and setup of MySQL, Kafka, Debezium, and ClickHouse, your real-time data synchronization system will be ready. 

To ensure smooth operation:
- Monitor Kafka topics and ensure they are correctly streaming data.
- Regularly check MySQL binlogs and Debezium connector status.
- Optimize ClickHouse ingestion performance for high throughput.

For further customization and advanced configurations, refer to the detailed installation guides linked above.



