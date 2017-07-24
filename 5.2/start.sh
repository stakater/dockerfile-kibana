#!/bin/bash
set -e

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

if [[ -n "$ELASTICSEARCH_URL" ]]; then
  sed -i 's|^\(#\+\)\?elasticsearch\.url:.*$|elasticsearch.url: '"\"$ELASTICSEARCH_URL\""'|' /opt/kibana/config/kibana.yml
elif [[ -n "$ELASTICSEARCH_SERVICE_NAME" ]]; then
  SVC_HOST=${ELASTICSEARCH_SERVICE_NAME}_SERVICE_HOST
  SVC_PORT=${ELASTICSEARCH_SERVICE_NAME}_SERVICE_PORT
  sed -i 's|^\(#\+\)\?elasticsearch\.url:.*$|elasticsearch.url: '"\"http://${!SVC_HOST}:${!SVC_PORT}\""'|' /opt/kibana/config/kibana.yml
fi

# Run as user "kibana" if the command is "kibana"
if [ "$1" = 'kibana' ]; then
	set -- su-exec stakater /sbin/tini -- "$@"
else
	# As argument is not related to kibana,
	# then assume that user wants to run his own process,
	# for example a `bash` shell to explore this image
	exec "$@"
fi
