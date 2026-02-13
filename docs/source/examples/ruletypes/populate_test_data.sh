#!/bin/bash

# Script to populate Elasticsearch with test data for ElastAlert2 testing

ES_HOST="http://localhost:9200"
INDEX_NAME="logs-test"

echo "=========================================="
echo "Populating Elasticsearch with test data"
echo "=========================================="

# Wait for Elasticsearch to be ready
echo "Waiting for Elasticsearch to be ready..."
until curl -s "$ES_HOST/_cluster/health" > /dev/null; do
  echo "Waiting for Elasticsearch..."
  sleep 2
done

echo "Elasticsearch is ready!"
echo ""

# Create test documents
echo "Creating test documents in index: $INDEX_NAME"
echo ""

# Get current timestamp for recent data
CURRENT_TIME=$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")
ONE_HOUR_AGO=$(date -u -v-1H +"%Y-%m-%dT%H:%M:%S.000Z" 2>/dev/null || date -u -d "1 hour ago" +"%Y-%m-%dT%H:%M:%S.000Z")
TWO_HOURS_AGO=$(date -u -v-2H +"%Y-%m-%dT%H:%M:%S.000Z" 2>/dev/null || date -u -d "2 hours ago" +"%Y-%m-%dT%H:%M:%S.000Z")
THREE_HOURS_AGO=$(date -u -v-3H +"%Y-%m-%dT%H:%M:%S.000Z" 2>/dev/null || date -u -d "3 hours ago" +"%Y-%m-%dT%H:%M:%S.000Z")
FOUR_HOURS_AGO=$(date -u -v-4H +"%Y-%m-%dT%H:%M:%S.000Z" 2>/dev/null || date -u -d "4 hours ago" +"%Y-%m-%dT%H:%M:%S.000Z")

# Document 1: Database error
echo "1. Creating ERROR log: Database connection failed (timestamp: $FOUR_HOURS_AGO)"
curl -X POST "$ES_HOST/$INDEX_NAME/_doc" \
  -H 'Content-Type: application/json' \
  -d "{
    \"@timestamp\": \"$FOUR_HOURS_AGO\",
    \"level\": \"ERROR\",
    \"message\": \"Database connection failed\",
    \"service\": \"api\",
    \"user\": \"john_doe\",
    \"host\": \"api-server-01\"
  }"
echo ""

# Document 2: Authentication error
echo "2. Creating ERROR log: Authentication failed (timestamp: $THREE_HOURS_AGO)"
curl -X POST "$ES_HOST/$INDEX_NAME/_doc" \
  -H 'Content-Type: application/json' \
  -d "{
    \"@timestamp\": \"$THREE_HOURS_AGO\",
    \"level\": \"ERROR\",
    \"message\": \"Authentication failed\",
    \"service\": \"auth\",
    \"user\": \"jane_smith\",
    \"host\": \"auth-server-01\"
  }"
echo ""

# Document 3: Timeout error
echo "3. Creating ERROR log: Timeout error (timestamp: $TWO_HOURS_AGO)"
curl -X POST "$ES_HOST/$INDEX_NAME/_doc" \
  -H 'Content-Type: application/json' \
  -d "{
    \"@timestamp\": \"$TWO_HOURS_AGO\",
    \"level\": \"ERROR\",
    \"message\": \"Timeout error\",
    \"service\": \"api\",
    \"user\": \"bob_jones\",
    \"host\": \"api-server-02\"
  }"
echo ""

# Document 4: INFO log (won't trigger alert)
echo "4. Creating INFO log (should not trigger alert) (timestamp: $ONE_HOUR_AGO)"
curl -X POST "$ES_HOST/$INDEX_NAME/_doc" \
  -H 'Content-Type: application/json' \
  -d "{
    \"@timestamp\": \"$ONE_HOUR_AGO\",
    \"level\": \"INFO\",
    \"message\": \"Request processed successfully\",
    \"service\": \"api\",
    \"user\": \"alice_wonder\",
    \"host\": \"api-server-01\"
  }"
echo ""

# Document 5: Another ERROR
echo "5. Creating ERROR log: Memory limit exceeded (timestamp: $CURRENT_TIME)"
curl -X POST "$ES_HOST/$INDEX_NAME/_doc" \
  -H 'Content-Type: application/json' \
  -d "{
    \"@timestamp\": \"$CURRENT_TIME\",
    \"level\": \"ERROR\",
    \"message\": \"Memory limit exceeded\",
    \"service\": \"worker\",
    \"user\": \"system\",
    \"host\": \"worker-01\"
  }"
echo ""

# Refresh index to make documents searchable
echo "Refreshing index to make documents searchable..."
curl -X POST "$ES_HOST/$INDEX_NAME/_refresh"
echo ""

echo ""
echo "=========================================="
echo "Test data populated successfully!"
echo "=========================================="
echo "Total ERROR logs created: 4"
echo "Total INFO logs created: 1"
echo ""
echo "You can now run: docker-compose up elastalert_test"
