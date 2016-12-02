# Kibana Docker Image

This is the Git repo for `stakater/kibana` docker image, based on `stakater/base` and inspired by the official kibana docker image repo.

How to run:

```
docker run stakater/kibana
```

With options:
```
docker run -d -p 5601:5601 -e ELASTICSEARCH_URL="<Elasticsearch host URL>" stakater/kibana
```