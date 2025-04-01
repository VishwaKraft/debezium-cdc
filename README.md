# Real-Time Data Synchronization & Event-Driven Architectures

## Problem Statement

### 1. Handling Database Changes Efficiently
When data is updated in relational databases like MySQL and PostgreSQL, downstream applications must react immediately. The main challenge is to extract and apply these changes in a simple and scalable way. Keeping database updates in sync with downstream applications is crucial to prevent data inconsistencies and performance bottlenecks.
<div style="display: flex; align-items: center;">
  <img src="https://github.com/user-attachments/assets/fcd631b6-6a60-42d1-b331-ea3fa211af92" alt="Database Changes" width="300" style="margin-right: 20px;"> 
</div>

### 2. Schema Evolution & Data Consistency
If due to some reason databases undergo schema changes over time. Ensuring that these changes do not break downstream applications or lead to inconsistencies is a critical requirement. Managing schema evolution properly avoids data corruption and ensures smooth application performance.
<div style="display: flex; align-items: center;">
  <img src="https://github.com/user-attachments/assets/c04363e9-d5ea-4857-b6d3-3590b23df09a" alt="Schema Evolution" width="300" style="margin-right: 20px;">
</div>

### 3. Keeping Multiple Systems in Sync
Traditional data synchronization methods, such as batch processing via ETL jobs and cron jobs, which significant introduce delays in data synchronization. However, businesses require real-time updates across various systems, including databases, analytics platforms, and search indexes, to make timely decisions and enhance user experience.
<div style="display: flex; align-items: center;">
  <img src="https://github.com/user-attachments/assets/070d3264-659a-449e-940d-a920a7f569a2" alt="Keeping Mutiple System in Sync" width="300" style="margin-right: 20px;">
</div>

### 4. Building Event-Driven Systems
Modern applications leverage event-driven architectures to enable functionalities such as microservices communication, real-time analytics, and fraud detection. However, streaming database changes as events without modifying existing applications remains a key challenge.
<div style="display: flex; align-items: center;">
  <img src="https://github.com/user-attachments/assets/43e2204c-28fb-4107-bc25-09db0a6e3e70" alt="Building Event-Driven Systems" width="300" style="margin-right: 20px;">
</div>

### 5. Fault Tolerance & Scalability
Polling-based approaches that periodically query databases introduce performance bottlenecks and are not scalable. A robust solution must provide fault tolerance while efficiently capturing and processing changes.
<div style="display: flex; align-items: center;">
  <img src="https://github.com/user-attachments/assets/1dd75a3f-bbc5-4b1d-9125-8fdb8d2a6e0f" alt="Fault Tolerance" width="300" style="margin-right: 20px;">
</div>

## Conclusion of Problem Statement

The above problem statements address the challenge of real-time data change propagation in distributed systems. These changes should be synchronized with other related systems in near real-time to ensure that downstream applications do not crash.

---

## Solution for This Problem Statement: Debezium for Change Data Capture (CDC)

### What is Debezium, and How Does It Track Changes in Data or a Database in Real-Time?

Debezium is an open-source Change Data Capture (CDC) tool that tracks database changes in real-time and streams them to external systems like Kafka. Debezium acts as a listener for database updates, capturing inserts, updates, and deletes without modifying the database itself.

---

## What is Debezium CDC?

--> Change Data Capture (CDC) refers to detecting and capturing changes (new data, updates, deletions) in a database.  
--> Debezium CDC is the process of continuously monitoring database logs and sending these changes as events to Kafka.

---

## Why Use Debezium CDC?

1. Provides real-time updates to other applications.  
2. Ensures data consistency across multiple systems.  
3. Avoids traditional slow batch processing (ETL jobs).

---

### **How Does Debezium Stream Changes to Kafka?**  
Debezium connects to a database and listens for changes using its transaction logs (binlog, WAL, etc.). Here's the flow:  

1️⃣ **Database Changes Occur** – A user inserts, updates, or deletes data in MySQL/PostgreSQL.  
2️⃣ **Debezium Captures Changes** – It reads database(transaction) logs (binlog for MySQL, WAL for PostgreSQL) to detect changes.  
3️⃣ **Debezium Sends Events to Kafka** – It transforms the changes into events and pushes them to **Kafka topics**.  
4️⃣ **Kafka Stores & Distributes Events** – Other applications can now read these events in real time and react accordingly. 

---
### **Example Flow:**  
Imagine an **e-commerce app** where inventory updates must sync across multiple services.  

- A customer buys a product → **Inventory in the database updates**  
- Debezium detects this change → Sends an event to **Kafka**  
- Kafka streams this update to services like:  
  ✅ Order Management  
  ✅ Warehouse System  
  ✅ Notification Service  

This ensures **real-time synchronization** without writing extra code for polling the database. 🚀  

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
---
### **Now, what is Kafka, and how is it involved in this process? Specifically, how does it help update downstream applications about the changes in near real time?**
### **What is Kafka?**  
**Apache Kafka** is an **open-source event streaming platform** that helps in **real-time data streaming** between systems. It acts as a **message broker**, allowing different applications to publish and consume data efficiently.  

- It is **distributed**, **fault-tolerant**, and **highly scalable**.  
- It is mainly used for **real-time event processing**, **log aggregation**, and **data streaming**.
- 
---

### **What is a Kafka Topic?**  
A **Kafka topic** is like a **channel** where data (events) are stored and categorized.  

- Producers (like **Debezium**) publish messages to topics.  
- Consumers (like **downstream applications**) subscribe to topics and receive messages.  
- Kafka topics **retain messages** for a configurable time, allowing multiple consumers to process them.  

📌 **Example:** If you have a database for customer orders, you can have a **Kafka topic named `customer_orders`** that receives updates when new orders are placed.  
An example of the messages that a **Kafka producer** might send when capturing changes from a database (like MySQL or PostgreSQL). These messages are often in a **JSON** format and represent events that downstream applications will consume.

### **Example 1: Insert Event**
Let’s say a new record is inserted into a `customer_orders` table in the database. Debezium will capture this insert event and produce a message to the Kafka topic `customer_orders`. The message could look like this:

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
    "version": "1.5.0.Final",
    "connector": "mysql",
    "name": "dbserver1",
    "ts_ms": 1585800000000,
    "snapshot": "false",
    "db": "ecommerce_db",
    "table": "customer_orders",
    "server_id": 223344,
    "gtid": null,
    "file": "mysql-bin.000001",
    "pos": 1543,
    "row": 1
  },
  "op": "c",  // 'c' stands for create (insert)
  "ts": 1585800000000
}
```

**Explanation of the Fields:**
- `"before"`: The state of the record before the change. In this case, it's `null` because it's an insert operation.
- `"after"`: The new state of the record after the change (new order data).
- `"source"`: Metadata about where the change originated from, such as the database (`dbserver1`), table (`customer_orders`), and other information to help track the change.
- `"op"`: The operation type. In this case, `c` stands for **create** (insert). Other operation types include `u` for update and `d` for delete.
---
### **How These Messages Help Update Downstream Systems**
- When the Kafka **consumer applications** (like microservices) listen to topics (e.g., `customer_orders`), they can process the events in real time.
- For example, when the **Order Processing Service** listens for an update event (status change from `PENDING` to `SHIPPED`), it can trigger further actions like **updating the inventory** or **sending notifications**.

---

### **How Kafka Captures Database Changes from Debezium?**  
Debezium **monitors database changes** and streams them to Kafka **topics**. The process works as follows:  

1️⃣ **Database Changes Occur**  
   - A new row is inserted, updated, or deleted in MySQL/PostgreSQL.  
   
2️⃣ **Debezium Captures the Change**  
   - It reads transaction logs (Binlog for MySQL, WAL for PostgreSQL).  
   
3️⃣ **Debezium Publishes the Change to Kafka**  
   - It converts the database change into an **event** and sends it to a Kafka topic.  
   - Example: A new customer order triggers an event in the topic **`customer_orders`**.  

4️⃣ **Kafka Stores the Event in the Topic**  
   - Kafka **stores** this event and ensures reliability.  
   - Multiple consumers can read the event simultaneously.  

5️⃣ **Downstream Systems Consume the Event**  
   - Different applications **subscribe to Kafka topics** and react to changes.  
   - Example:  
     - **Order Processing Service** updates inventory.  
     - **Notification Service** sends an email to the customer.  
     - **Analytics System** logs the transaction for reporting.  

---

### **How Do Downstream Applications Get Updated?**  
Downstream systems act as **Kafka consumers** that listen for changes and take action.  

📌 **Example Flow for an E-commerce System:**  
- **Order Table Updated in MySQL** (`INSERT INTO orders ...`)  
- **Debezium Captures This Change**  
- **Debezium Pushes the Event to Kafka Topic `customer_orders`**  
- **Order Processing Microservice Listens to This Topic**  
- **Order Processing Service Updates Inventory & Sends Confirmation Email**  

This ensures **real-time synchronization** of database changes **without polling**.  

---

### **Why Use Kafka for CDC?**  
✅ **Decouples Systems** – Database changes are **captured once** and distributed to **multiple consumers**.  
✅ **Real-Time Updates** – No need for slow batch jobs or cron scripts.  
✅ **Fault-Tolerant & Scalable** – Kafka handles high loads efficiently.  
✅ **Ensures Data Consistency** – Guarantees order and durability of messages.  

---
# What is ClickHouse and Why do we need it? 
ClickHouse is an **open-source columnar database** designed for **real-time analytics** and high-speed data processing. It is optimized for handling large-scale data, making it ideal for use cases like log analysis, business intelligence, and event tracking.  

- **Extremely Fast Queries** – ClickHouse is **column-oriented**, meaning it processes queries much faster than traditional row-based databases like MySQL or PostgreSQL.🚀
- **Scalable & Distributed** – It can handle terabytes of data efficiently.🔗  
- **Ideal for Analytics** – Used for real-time reporting, dashboards, and aggregations.📊

---
## **Why Do We Need ClickHouse in This Setup?**  
ClickHouse is essential in this **Debezium → Kafka → ClickHouse** pipeline because it provides **real-time analytics on database changes** without affecting the performance of the transactional database.  

### **1️⃣ Traditional Databases Are Not Optimized for Analytics**  
Relational databases like **MySQL, PostgreSQL, or SQL Server** are **designed for transactions (OLTP)**, not for high-speed analytical queries (OLAP). Running complex aggregations or reports on these databases **slows down the system**, especially with large datasets.  

🔴 **Problem:** If you directly query MySQL for analytics on **millions of records**, your application might slow down.  
✅ **Solution:** ClickHouse stores data **efficiently** and can **query millions of rows per second** without impacting the main database.  

---

### **2️⃣ Kafka Holds the Events, But Cannot Query Data Efficiently**  
Kafka is great for **real-time event streaming**, but it is **not a database**.  
- Kafka **does not support SQL queries**.  
- Kafka **only retains messages for a short time** (based on log retention settings).  
- If you want to analyze historical data, you need to **store it somewhere**.  

✅ **Solution:** ClickHouse acts as a **real-time analytics database**, storing all Kafka events for fast querying.  

---

### **3️⃣ ClickHouse Allows Real-Time Analytics on Change Data Capture (CDC)**  
Since **Debezium streams every database change** to Kafka, we can push these changes into ClickHouse to perform **real-time** analytics, such as:  

📊 **Example Use Cases:**  
- **Tracking order trends in e-commerce** (e.g., how many orders were placed in the last 10 minutes).  
- **Monitoring financial transactions for fraud detection**.  
- **Analyzing user activity logs in real time**.  
- **Generating dashboards for business intelligence**.  

✅ **Solution:** ClickHouse allows instant queries on **billions of records**, unlike MySQL/PostgreSQL, which would be much slower for the same task.  

---

### **4️⃣ ClickHouse Handles Large-Scale Data Efficiently**  
ClickHouse is a **columnar database**, which means:  
- It stores data **column-wise** instead of row-wise, making aggregations (like `COUNT`, `SUM`, `AVG`) much faster.  
- It **compresses data efficiently**, using less storage space.  
- It can **handle terabytes of data** without performance issues.  

🔴 **Problem:** A PostgreSQL table with 1 billion records would take minutes to run `SELECT COUNT(*)`.  
✅ **Solution:** ClickHouse can return the result **within milliseconds**.  

---

### **5️⃣ ClickHouse Eliminates the Need for Batch Jobs (ETL)**  
In traditional setups, businesses use **ETL (Extract, Transform, Load) pipelines** to sync MySQL/PostgreSQL data into a **data warehouse** like Snowflake or BigQuery.  
- **Batch jobs run every few hours or days**, delaying updates.  
- **Data is stale** when reports are generated.  

✅ **Solution:** **ClickHouse + Kafka** enables **real-time data processing**, so reports & dashboards **always show live data**.  

---

## **Summary: Why ClickHouse?**
| **Feature**           | **MySQL/PostgreSQL**  | **Kafka**          | **ClickHouse**         |
|-----------------------|----------------------|--------------------|------------------------|
| **Transaction Processing (OLTP)** | ✅ Good | ❌ Not designed for OLTP | ❌ Not for transactions |
| **Streaming Data** | ❌ Not real-time | ✅ Real-time | ✅ Real-time ingestion |
| **Querying & Aggregations** | ❌ Slow for large datasets | ❌ No SQL support | ✅ Fast columnar storage |
| **Data Retention** | ✅ Permanent | ❌ Temporary | ✅ Permanent |
| **Historical Data Analysis** | ❌ Not optimized | ❌ Hard to store/query | ✅ Excellent for analytics |

📌 **Final Answer:** **ClickHouse is needed to efficiently store and analyze real-time database changes without affecting performance.** 🚀  

Would you like a **step-by-step guide** to set up ClickHouse as a Kafka Sink? 😊
## **What is a ClickHouse Sink & How Does It Work with Kafka?**  
A **sink** in Kafka terminology refers to a **consumer** that reads data from a Kafka topic and writes it to another storage system (like ClickHouse).  

A **ClickHouse Sink** is a **Kafka Connect sink connector** that **automatically ingests** data from Kafka topics into ClickHouse tables.  

### **How It Works with Debezium & Kafka:**
1️⃣ **Database Changes Occur**  
   - A new order is placed (INSERT), updated (UPDATE), or deleted (DELETE) in MySQL/PostgreSQL.  

2️⃣ **Debezium Captures the Change & Publishes It to Kafka**  
   - Debezium streams this event as a Kafka message in a **Kafka topic** (`customer_orders`).  

3️⃣ **Kafka Connect ClickHouse Sink Listens to Kafka Topics**  
   - The ClickHouse sink connector **subscribes** to the Kafka topic and reads the events.  

4️⃣ **ClickHouse Stores the Data for Analytics**  
   - The connector writes the Kafka event data into ClickHouse tables for **real-time analytics and reporting**.  

---

## **Example Setup: Debezium → Kafka → ClickHouse**
📌 **Use Case:** Tracking user purchases in an **e-commerce** system.  

🔹 **Step 1: Database Change (MySQL/PostgreSQL)**  
```sql
INSERT INTO orders (order_id, customer_id, total_amount, status) VALUES (12345, 6789, 199.99, 'PENDING');
```

🔹 **Step 2: Debezium Captures & Publishes to Kafka (`orders` topic)**  
Kafka Message:  
```json
{
  "order_id": 12345,
  "customer_id": 6789,
  "total_amount": 199.99,
  "status": "PENDING"
}
```

🔹 **Step 3: ClickHouse Sink Reads the Kafka Topic (`orders` topic)**  
- The **ClickHouse Kafka engine** automatically **reads the message** from Kafka and writes it into a ClickHouse table.  

🔹 **Step 4: ClickHouse Table Stores the Data**  
```sql
CREATE TABLE orders (
    order_id UInt64,
    customer_id UInt64,
    total_amount Float64,
    status String
) ENGINE = MergeTree() ORDER BY order_id;
```

🔹 **Step 5: Running Analytics Queries in ClickHouse**  
```sql
SELECT COUNT(*) FROM orders WHERE status = 'PENDING';
```
✅ **Result:** Get **real-time insights** on pending orders!  

---

### **Conclusion: Why Use ClickHouse with Kafka & Debezium?**  
📌 **Debezium** captures real-time changes from the database.  
📌 **Kafka** acts as the streaming pipeline.  
📌 **ClickHouse** stores the data for **fast analytics & reporting**.  

This architecture allows businesses to **react to changes instantly** while maintaining **high-performance analytics** on fresh data. 🚀 
---
# Conclusion
---

### **📌 Data Flow Summary**
1️⃣ **Database Change (Insert/Update/Delete) Happens** → (Example: A new order is placed in MySQL/PostgreSQL).  
⬇️  
2️⃣ **Debezium Captures the Change** → (Reads database logs and converts them into CDC events).  
⬇️  
3️⃣ **Kafka Acts as the Message Broker** → (Debezium publishes CDC events to Kafka topics).  
⬇️  
4️⃣ **Kafka Connect ClickHouse Sink Reads the Topic** → (Consumes events from Kafka and writes them to ClickHouse).  
⬇️  
5️⃣ **ClickHouse Stores Data for Analytics** → (Real-time queries on updated data for dashboards, fraud detection, etc.).  

---

### **📊 Workflow Diagram**
```
[ MySQL/PostgreSQL ]  
       │  (1️⃣ Change Happens)  
       ▼  
[ Debezium ]  --- Captures Change Logs --->  
       ▼  
[ Kafka (CDC Topics) ]  --- Streams Data --->  
       ▼  
[ Kafka Connect ClickHouse Sink ]  --- Consumes & Writes --->  
       ▼  
[ ClickHouse ]  --- Stores & Provides Fast Queries --->  
       ▼  
[ Dashboards, Reports, Analytics ]
```

---
🚀 **This enables instant insights into database changes without affecting transactional database performance!**

