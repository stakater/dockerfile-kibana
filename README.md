# Kibana Docker Image

### Supported tags and respective Dockerfile links
* 5.2, 5.2.1, latest ([5.2/Dockerfile](https://github.com/stakater/dockerfile-kibana/blob/master/5.2/Dockerfile))
* 4.5 ([4.5/Dockerfile](https://github.com/stakater/dockerfile-kibana/blob/master/4.5/Dockerfile))

This is the Git repo for `stakater/kibana` docker image, based on `stakater/base` and inspired by the official kibana docker image repo.


How to run:

```
docker run stakater/kibana
```

With options:
```
docker run -d -p 5601:5601 -e ELASTICSEARCH_URL="<Elasticsearch host URL>" stakater/kibana
```