FROM	stakater/base-alpine:3.7
LABEL 	authors="Stakater"

RUN 	apk add --no-cache --progress nodejs=8.9.3-r0

ARG 	KIBANA_VERSION=6.1.0
ARG		KIBANA_HOME=/opt/kibana
ARG 	UID=1000
ARG 	GID=1000

ENV		KIBANA_TARBALL="https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz" \
		KIBANA_TARBALL_ASC="https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz.asc" \
		KIBANA_TARBALL_SHA1="ec075b0073ea380879a112b70df68bd4178e3b1e" \
		# https://artifacts.elastic.co/GPG-KEY-elasticsearch
		GPG_KEY=46095ACC8548582C1A2699A9D27D666CD88E42B4 \
		KIBANA_HOME=${KIBANA_HOME} \
		PATH=${KIBANA_HOME}/bin:$PATH

RUN 	addgroup -g ${GID} kibana && \
    	adduser -D -u ${UID} -G kibana kibana && \
		# Kibana installation directory
		mkdir -p ${KIBANA_HOME} && chown kibana:kibana ${KIBANA_HOME}

WORKDIR ${KIBANA_HOME}

ENV 	KIBANA_HOST=0.0.0.0 \
		ELASTICSEARCH_HOST="" \
		ELASTICSEARCH_PORT=9200 \
		# For connecting to elasticsearch with SSL set to https
		ELASTICSEARCH_PROTOCOL=http

RUN 	set -ex; \
		\
		apk add --no-cache --virtual .fetch-deps \
			ca-certificates \
			gnupg \
			openssl \
			tar \
		; \
		\
		wget -O kibana.tar.gz "$KIBANA_TARBALL"; \
		\
		if [ "$KIBANA_TARBALL_SHA1" ]; then \
			echo "$KIBANA_TARBALL_SHA1 *kibana.tar.gz" | sha1sum -c -; \
		fi; \
		\
		if [ "$KIBANA_TARBALL_ASC" ]; then \
			wget -O kibana.tar.gz.asc "$KIBANA_TARBALL_ASC"; \
			export GNUPGHOME="$(mktemp -d)"; \
			gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY" \
  				|| gpg --keyserver pgp.mit.edu --recv-keys "$GPG_KEY" \
  				|| gpg --keyserver keyserver.pgp.com --recv-keys "$GPG_KEY"; \
			gpg --batch --verify kibana.tar.gz.asc kibana.tar.gz; \
			rm -r "$GNUPGHOME" kibana.tar.gz.asc || true; \
		fi; \
		\
		tar -xf kibana.tar.gz --strip-components=1; \
		rm kibana.tar.gz; \
		\
		apk del .fetch-deps; \
		\
		mkdir -p ./plugins; \
		for path in \
			./data \
			./logs \
			./config \
			./config/scripts \
		; do \
			mkdir -p "$path"; \
			chown -R kibana:kibana "$path"; \
		done; \
		# remove local node that came with kibana, as it gives error while
		# trying to run on alpine, kibana will use pre-installed 
		rm -rf ${KIBANA_HOME}-linux-x86_64/node && \
		mkdir -p ${KIBANA_HOME}/node/bin &&\
		ln -sf /usr/bin/node ${KIBANA_HOME}/node/bin/node 

# Add config file
ADD 	./config/kibana.yml ${KIBANA_HOME}/config/kibana.yml

# Simulate CMD behavior via environment variable
# So that users are able to provice command line arguments to the app
ENV 	COMMAND "kibana"

EXPOSE 	5601

# Make daemon service dir for kibana and place file
# It will be started and maintained by the base image
RUN 	mkdir -p /etc/service/kibana
ADD 	start.sh /etc/service/kibana/run

# Use base image's entrypoint