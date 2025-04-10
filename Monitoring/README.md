# How to Monitor

## Add the Data Source

1. Open your browser and go to: [http://localhost:3000](http://localhost:3000)  
2. Log in to **Grafana** (default user/pass: `admin` / `admin` if not changed).  
3. Click on **"Data Sources"** from the left menu.  
4. Click **"Add data source"**, then select **Prometheus**.  
5. Enter a name (e.g., `prometheus`).  
6. In the **URL** field under *HTTP > URL*, enter:  
   ```
   http://prometheus:9090
   ```
7. Click **"Save & Test"**.  
8. You should see a success message confirming the connection.

---

## Add Dashboards

1. Click on **"Dashboards" > "Import"** from the left menu.  
2. Choose or upload the `Mysql_Dashboard.json` file.  
3. When prompted, select the data source (`prometheus`) you just created.  
4. Click **"Import"** to add the dashboard.  

> Repeat the same steps to import a dashboard for **Kafka**, using a corresponding `Kafka_Dashboard.json` file.

---
