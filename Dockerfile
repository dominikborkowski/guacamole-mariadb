FROM guacamole/guacamole:1.0.0 as guac_client
ARG GUACAMOLE_DATABASE=guac_db

LABEL maintainer="Dominik L. Borkowski"

# generate initial schema from our guacamole client
RUN echo "USE ${GUACAMOLE_DATABASE};" > /tmp/guacamole-initdb.sql && \
    /opt/guacamole/bin/initdb.sh --mysql >> /tmp/guacamole-initdb.sql

# prepare a new mariadb container
FROM yobasystems/alpine-mariadb:latest
COPY --from=guac_client ./tmp/guacamole-initdb.sql /docker-entrypoint-initdb.d/guacamole-initdb.sql
