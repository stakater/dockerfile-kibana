#!/bin/bash

CMD="kibana"
set -e
if [ "$ELASTICSEARCH_URL" ]; then
	sed -ri "s!^(\#\s*)?(elasticsearch\.url:).*!\2 '$ELASTICSEARCH_URL'!" /opt/kibana/config/kibana.yml
fi

if [ "$SERVER_BASEPATH" ]; then
	sed -ri "s!^(\#\s*)?(server\.basePath:).*!\2 '$SERVER_BASEPATH'!" /opt/kibana/config/kibana.yml
fi

set -- gosu kibana tini -- $CMD

exec $CMD
