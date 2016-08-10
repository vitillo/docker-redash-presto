##docker-redash-hive
Dockerized redash pre-configured with a Hive data source.

###Build
docker build -t mozdata/docker-redash-hive:${VERSION} .

###Docker Hub
docker push mozdata/docker-redash-hive:${VERSION}
