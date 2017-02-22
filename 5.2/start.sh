#!/bin/bash
set -e

# Add kibana as command if needed
if [[ "$COMMAND" == -* ]]; 
then
	set -- kibana "$COMMAND"
fi

# Run as user "kibana" if the command is "kibana"
if [ "$COMMAND" = 'kibana' ]; 
then
	if [ "$ELASTICSEARCH_URL" ]; then
		sed -ri "s!^(\#\s*)?(elasticsearch\.url:).*!\2 '$ELASTICSEARCH_URL'!" /opt/kibana/config/kibana.yml
	fi

	set -- su-exec stakater /sbin/tini -- "$COMMAND"
else
	# As argument is not related to kibana,
	# then assume that user wants to run his own process,
	# for example a `bash` shell to explore this image
	exec "$COMMAND";
fi