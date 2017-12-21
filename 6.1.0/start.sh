#!/bin/bash
set -e

# Env variables for config
export KIBANA_HOST=${KIBANA_HOST:-0.0.0.0}
export ELASTICSEARCH_HOST=${ELASTICSEARCH_HOST:-elasticsearch}
export ELASTICSEARCH_PORT=${ELASTICSEARCH_PORT:-9200}
export ELASTICSEARCH_PROTOCOL=${ELASTICSEARCH_PROTOCOL:-http}

# Convert COMMAND variable into an array 
# Simulating positional parameter behaviour 
IFS=' ' read -r -a CMD_ARRAY <<< "$COMMAND"

# explicitly setting positional parameters ($@) to CMD_ARRAY
# Add kibana as command if needed i.e. when 
# first arg is `-f` or `--some-option` 
if [ "${CMD_ARRAY[0]:0:1}" = '-' ]; then
	set -- kibana "${CMD_ARRAY[@]}"
else
	set -- "${CMD_ARRAY[@]}"
fi

CONF="${KIBANA_HOME}/config/kibana.yml"

# Run as user "kibana" if the command is "kibana"
if [ "$1" = 'kibana' ]; 
then
	sed -ri "s|elasticsearch.url:[^\r\n]*|elasticsearch.url: ${ELASTICSEARCH_PROTOCOL}://$ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT|" "$CONF"
	sed -i "s;.*server\.host:.*;server\.host: ${KIBANA_HOST};" "$CONF"
	set -- su-exec kibana "$@"
fi

# Execute
exec "$@"
