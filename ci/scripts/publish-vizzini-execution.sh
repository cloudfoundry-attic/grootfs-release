#!/bin/bash

export $IAAS
export "$DATADOG_API_KEY"
curl  -X POST -H "Content-type: application/json" \
  -d '{
        "title": "Vizzini errand just finished",
        "text": "YAAAAAY!!",
        "tags": ["vizzini", "$ENV"]
    }' \
  "https://app.datadoghq.com/api/v1/events?api_key=$DATADOG_API_KEY"
