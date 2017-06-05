#!/bin/bash

curl  -X POST -H "Content-type: application/json" \
  -d "{
        \"title\": \"${EVENT_NAME}\",
        \"text\": \"${EVENT_NAME}\",
        \"tags\": [\"$TAG\"]
    }" \
  "https://app.datadoghq.com/api/v1/events?api_key=$DATADOG_API_KEY"
