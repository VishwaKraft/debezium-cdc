# Real-Time Data Synchronization Architecture using Debezium CDC, MySQL, Kafka, and ClickHouse

## Overview
Debezium is an open-source Change Data Capture (CDC) tool that tracks database changes in real time and streams them to external systems like Kafka. It captures inserts, updates, and deletes without modifying the database itself, enabling seamless data synchronization across different applications.

![Debezium](./images/debezium-architecture.png)
<div style="display: flex; justify-content: center; gap: 20px;">
    <img src="https://github.com/Datavolt/debezium-cdc/blob/main/docs/images/Workflow%201.png" alt="Workflow 1" width="45%">
    <img src="https://github.com/Datavolt/debezium-cdc/blob/main/docs/images/Workflow%202.png" alt="Workflow 2" width="45%">
</div>

---
## What is Debezium CDC?
CDC (Change Data Capture) is the process of detecting and capturing changes (new data, updates, deletions) in a database. Debezium continuously monitors database logs and sends these changes as structured events to Kafka topics.

### **Key Benefits of Using Debezium CDC:**
1. **Real-time data updates** for downstream applications.
2. **Ensures data consistency** across multiple services.
3. **Eliminates traditional ETL batch jobs**, improving efficiency.

---
## **How Debezium Streams Changes to Kafka**
Debezium connects to a database and listens for changes using its transaction logs (binlog, WAL, etc.). The process follows this sequence:

1️⃣ **Database Changes Occur** – Inserts, updates, or deletes happen in MySQL/PostgreSQL.

2️⃣ **Debezium Captures Changes** – It reads transaction logs (e.g., binlog for MySQL, WAL for PostgreSQL) to detect modifications.

3️⃣ **Debezium Sends Events to Kafka** – It transforms database changes into structured events and publishes them to Kafka topics.

4️⃣ **Kafka Stores & Distributes Events** – Downstream applications subscribe to Kafka topics and react in real time.

---
## **Example Flow: Real-Time Inventory Sync in an E-commerce App**
1. A **customer purchases a product** → Inventory in the database updates.
2. **Debezium detects this change** and publishes an event to Kafka.
3. Kafka streams this update to multiple services:
   ✅ **Order Management System**
   
   ✅ **Warehouse Management**
   
   ✅ **Notification Service**
5. **Each system updates accordingly**, ensuring real-time synchronization without polling the database.

---
## **Role of Kafka in the CDC Process**
### **What is Kafka?**
Apache Kafka is an open-source event streaming platform that facilitates real-time data exchange between systems. It acts as a message broker, ensuring efficient, scalable, and fault-tolerant data processing.

### **Kafka Topics**
- A **Kafka topic** is a data channel where messages are stored and categorized.
- **Producers** (e.g., Debezium) publish messages to topics.
- **Consumers** (e.g., microservices, ClickHouse) subscribe to topics and process messages.
- Kafka topics **retain messages** for a configurable duration, allowing multiple consumers to process them asynchronously.

📌 **Example Kafka Topic:** `customer_orders`
When a new order is placed, an event is published to the `customer_orders` topic, which downstream services consume for further processing.

---
## **Example: Insert Event in Kafka**
When a new order is inserted into the `customer_orders` table, Debezium captures this and publishes an event in JSON format:

```json
{
  "before": null,
  "after": {
    "order_id": 12345,
    "customer_id": 6789,
    "order_date": "2025-04-01T12:00:00Z",
    "total_amount": 199.99,
    "status": "PENDING"
  },
  "source": {
    "connector": "mysql",
    "db": "ecommerce_db",
    "table": "customer_orders"
  },
  "op": "c"  // 'c' stands for create (insert)
}
```

### **How Downstream Applications React**
- Kafka consumers, such as microservices, listen for changes.
- The **Order Processing Service** updates inventory.
- The **Notification Service** sends a confirmation email.
- **ClickHouse** stores events for analytics and reporting.

---
## **Integration with ClickHouse for Real-Time Analytics**
ClickHouse, a high-performance OLAP database, can be integrated with Kafka to process Debezium events for analytical workloads.

### **Data Flow to ClickHouse:**
1. **Kafka Receives Events** – Debezium streams database changes to Kafka.
2. **Kafka Connect Moves Data to ClickHouse** – Using Kafka Connect’s ClickHouse sink connector.
3. **ClickHouse Processes and Aggregates Data** – Provides real-time analytics for reporting.

📌 **Example:**
- Analyzing **real-time sales trends** by aggregating `customer_orders` data in ClickHouse.
- Tracking **inventory updates** to prevent stock shortages.

---
## **End-to-End Architecture Overview**
### **Real-Time CDC Workflow**
1️⃣ **MySQL Database** → Stores operational data.

2️⃣ **Debezium** → Captures data changes from MySQL binlog.

3️⃣ **Kafka** → Acts as the event broker.

4️⃣ **Kafka Consumers**:
   - **Microservices** → Process business logic.
   - **ClickHouse** → Stores analytical data.
   - **Other downstream applications** → React in real-time.

---
## **Why Use Kafka for CDC?**
✅ **Decouples Systems** – Captures database changes once and distributes them to multiple consumers.

✅ **Real-Time Updates** – No need for batch jobs or cron scripts.

✅ **Scalability & Fault Tolerance** – Handles large-scale data changes efficiently.

✅ **Data Consistency** – Ensures ordered and durable message delivery.

---
## **Conclusion**
Debezium, Kafka, and ClickHouse together form a powerful architecture for **real-time data synchronization**. This approach ensures **low-latency data updates**, **eliminates batch jobs**, and provides **real-time analytics**, making it ideal for **high-performance applications** like e-commerce, finance, and IoT.

🚀 **Implementing this architecture guarantees a scalable and efficient real-time data pipeline for modern applications.**

