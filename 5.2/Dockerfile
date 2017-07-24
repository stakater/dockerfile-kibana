FROM stakater/node:6.9
LABEL authors="Hazim <hazim_malik@hotmail.com>"

# grab su-exec for easy step-down from root
# grab tini for signal processing and zombie killing
RUN apk add --no-cache 'su-exec>=0.2' tini
# Tini is now available at /sbin/tini

# Kibana installation directory
RUN mkdir -p /opt/kibana
WORKDIR /opt/kibana

# https://artifacts.elastic.co/GPG-KEY-elasticsearch
ENV GPG_KEY 46095ACC8548582C1A2699A9D27D666CD88E42B4

ENV KIBANA_MAJOR 5.2
ARG KIBANA_VERSION=5.2.1
ENV KIBANA_TARBALL="https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz" \
	KIBANA_TARBALL_ASC="https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz.asc" \
	KIBANA_TARBALL_SHA1="065cc4cb6936e462120dd114c336e5802c874edb"

RUN set -ex; \
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
		gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY"; \
		gpg --batch --verify kibana.tar.gz.asc kibana.tar.gz; \
		rm -r "$GNUPGHOME" kibana.tar.gz.asc; \
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
		chown -R stakater:stakater "$path"; \
	done; \
# If node is already installed remove local node
# that came with kibana, as it gives error while
# trying to run on alpine kibana will use pre-installed 
	NODE=$(which node); \
	if [ -x "$NODE" ] && [ -d "./node" ]; then \ 
		rm -rf node; \
	fi;

RUN chmod 777 /opt/kibana/config/ /opt/kibana/optimize/ && \
    chmod 666 /opt/kibana/config/kibana.yml /opt/kibana/optimize/.babelcache.json

# ensure the default configuration is useful when using --link
#RUN set -x \
#	&& sed -ri "s!^(\#\s*)?(elasticsearch\.url:).*!\2 'http://elasticsearch:9200'!" /opt/kibana/config/kibana.yml \
#	&& grep -q 'elasticsearch:9200' /opt/kibana/config/kibana.yml

ENV PATH /opt/kibana/bin:$PATH

# Simulate CMD behavior via environment variable
# So that users are able to provide command line arguments to the app
ENV COMMAND "kibana"

EXPOSE 5601

# Make daemon service dir for kibana and place file
# It will be started and maintained by the base image
RUN mkdir -p /etc/service/kibana
ADD start.sh /etc/service/kibana/run

# Use base image's entrypoint