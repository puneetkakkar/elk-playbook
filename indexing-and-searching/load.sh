#!/bin/bash

# Check if dotenv is installed, and source the .env file
if [ -f ../.env ]; then
	export $(grep -v '^#' ../.env | xargs)
else
	echo "No .env file found. Please create one with URL, USERNAME, and PASSWORD."
	exit 1
fi

printf "\n**Load.sh loads an index template and an ingest pipeline to process Apache web logs into Elasticsearch**\n\n"

# load index template
if curl -f -XPUT "$ELASTIC_CLUSTER_URL/_index_template/web-logs" -u $ELASTIC_USERNAME:$ELASTIC_PASSWORD -H 'Content-Type: application/json' -k -d "@web-logs-template.json"; then
	echo " - Loaded index template for web logs"
else
	echo " Could not load index template"
	exit
fi

# load ingest pipeline
if curl -f -XPUT "$ELASTIC_CLUSTER_URL/_ingest/pipeline/web-logs" -u $ELASTIC_USERNAME:$ELASTIC_PASSWORD -H 'Content-Type: application/json' -k -d "@web-logs-pipeline.json"; then
	echo " - Loaded ingest pipeline for Apache"
else
	echo " Could not load ingest pipeline for Apache"
	exit
fi

printf "\n*Loaded components successfully\n"
