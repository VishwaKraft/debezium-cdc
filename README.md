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
  <img src="https://github.com/user-attachments/assets/070d3264-659a-449e-940d-a920a7f569a2" alt="Schema Evolution" width="300" style="margin-right: 20px;">
</div>

### 4. Building Event-Driven Systems
Modern applications leverage event-driven architectures to enable functionalities such as microservices communication, real-time analytics, and fraud detection. However, streaming database changes as events without modifying existing applications remains a key challenge.
<div style="display: flex; align-items: center;">
  <img src="https://github.com/user-attachments/assets/43e2204c-28fb-4107-bc25-09db0a6e3e70" alt="Schema Evolution" width="300" style="margin-right: 20px;">
</div>

### 5. Fault Tolerance & Scalability
Polling-based approaches that periodically query databases introduce performance bottlenecks and are not scalable. A robust solution must provide fault tolerance while efficiently capturing and processing changes.
<div style="display: flex; align-items: center;">
  <img src="https://github.com/user-attachments/assets/1dd75a3f-bbc5-4b1d-9125-8fdb8d2a6e0f" alt="Schema Evolution" width="300" style="margin-right: 20px;">
</div>

## Conclusion of problem statement 
The above problem statements addressing the problem of real-time data change propagation in distributed system. 
