FROM redash/redash:0.12.0.b2118
MAINTAINER ra.vitillo@gmail.com

ENV DOCKERIZE_VERSION v0.2.0

RUN pip install --upgrade git+https://github.com/vitillo/PyHive.git@pretty && \
    apt-get update && \
    apt-get install -y postgresql-client && \
    wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

ADD resources/entrypoint.sh entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
CMD ["supervisord", "-c", "/opt/redash/supervisord/supervisord.conf"]