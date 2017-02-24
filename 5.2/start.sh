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

# Run as user "kibana" if the command is "kibana"
if [ "$1" = 'kibana' ]; 
then
	if [ "$ELASTICSEARCH_URL" ]; then
		sed -ri "s!^(\#\s*)?(elasticsearch\.url:).*!\2 '$ELASTICSEARCH_URL'!" /etc/kibana/kibana.yml
	fi
	set -- su-exec stakater /sbin/tini -- "$@"
else 
	# As argument is not related to kibana,
	# then assume that user wants to run his own process,
	# for example a `bash` shell to explore this image
	exec "$@"
fi
