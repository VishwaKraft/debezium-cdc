#!/bin/bash

# MySQL Connector Setup Script for JMX Testing
# This script registers the MySQL connector with Debezium Connect

set -e

CONNECTOR_CONFIG_FILE="mysql-connector-config.json"
DEBEZIUM_CONNECT_URL="http://localhost:8083"

echo "=== MySQL Connector Setup for JMX Testing ==="

# Wait for Debezium Connect to be ready
echo "Waiting for Debezium Connect to be ready..."
for i in {1..30}; do
    if curl -s "$DEBEZIUM_CONNECT_URL" > /dev/null 2>&1; then
        echo "Debezium Connect is ready!"
        break
    fi
    echo "Attempt $i: Waiting for Debezium Connect..."
    sleep 2
done

# Check if Debezium Connect is ready
if ! curl -s "$DEBEZIUM_CONNECT_URL" > /dev/null 2>&1; then
    echo "Error: Debezium Connect is not accessible at $DEBEZIUM_CONNECT_URL"
    exit 1
fi

# Get available connector plugins
echo -e "\n=== Available Connector Plugins ==="
curl -s "$DEBEZIUM_CONNECT_URL/connector-plugins" | jq '.[] | select(.class | contains("mysql")) | {class: .class, type: .type, version: .version}'

# Check if connector already exists
echo -e "\n=== Checking for Existing Connector ==="
if curl -s "$DEBEZIUM_CONNECT_URL/connectors/mysql-connector" > /dev/null 2>&1; then
    echo "MySQL connector already exists. Deleting it first..."
    curl -X DELETE "$DEBEZIUM_CONNECT_URL/connectors/mysql-connector"
    sleep 2
fi

# Register the connector
echo -e "\n=== Registering MySQL Connector ==="
if [ ! -f "$CONNECTOR_CONFIG_FILE" ]; then
    echo "Error: Connector config file $CONNECTOR_CONFIG_FILE not found"
    exit 1
fi

RESPONSE=$(curl -s -X POST \
    -H "Content-Type: application/json" \
    --data @"$CONNECTOR_CONFIG_FILE" \
    "$DEBEZIUM_CONNECT_URL/connectors")

echo "Response: $RESPONSE"

# Verify connector status
echo -e "\n=== Checking Connector Status ==="
sleep 5  # Give connector time to start

for i in {1..10}; do
    STATUS=$(curl -s "$DEBEZIUM_CONNECT_URL/connectors/mysql-connector/status" 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo "Connector Status:"
        echo "$STATUS" | jq '.'
        
        # Check if connector is running
        CONNECTOR_STATE=$(echo "$STATUS" | jq -r '.connector.state' 2>/dev/null)
        if [ "$CONNECTOR_STATE" = "RUNNING" ]; then
            echo -e "\n✅ MySQL Connector is successfully running!"
            break
        else
            echo "Connector state: $CONNECTOR_STATE (attempt $i/10)"
        fi
    else
        echo "Failed to get connector status (attempt $i/10)"
    fi
    sleep 3
done

# List all connectors
echo -e "\n=== All Registered Connectors ==="
curl -s "$DEBEZIUM_CONNECT_URL/connectors" | jq '.'

# Show topics
echo -e "\n=== Checking Kafka Topics ==="
echo "You can check topics in Kafka UI at: http://localhost:8080"

echo -e "\n=== Setup Complete! ==="
echo "MySQL Connector is ready for JMX testing."
echo "Access Points:"
echo "- Debezium Connect API: $DEBEZIUM_CONNECT_URL"
echo "- Kafka UI: http://localhost:8080"  
echo "- Debezium UI: http://localhost:8084"
echo ""
echo "Test the connector by running SQL operations on MySQL:"
echo "docker exec -it mysql-cdc mysql -uroot -proot testdb"
