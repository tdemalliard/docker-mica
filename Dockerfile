#
# Mica Dockerfile
#
# https://github.com/obiba/docker-mica
#

# Pull base image
FROM openjdk:8

MAINTAINER OBiBa <dev@obiba.org>

# grab gosu for easy step-down from root
# see https://github.com/tianon/gosu/blob/master/INSTALL.md
ENV GOSU_VERSION 1.10
ENV GOSU_KEY B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN set -ex; \
  \
  fetchDeps=' \
    ca-certificates \
    wget \
  '; \
  apt-get update; \
  apt-get install -y --no-install-recommends $fetchDeps; \
  rm -rf /var/lib/apt/lists/*; \
  \
  dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
  wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
  wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
  \
# verify the signature
  export GNUPGHOME="$(mktemp -d)"; \
  gpg --keyserver pgp.mit.edu --recv-keys "$GOSU_KEY" || \
  gpg --keyserver keyserver.pgp.com --recv-keys "$GOSU_KEY" || \
  gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GOSU_KEY"; \
  gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
  rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
  \
  chmod +x /usr/local/bin/gosu; \
# verify that the binary works
  gosu nobody true;

ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

ENV MICA_ADMINISTRATOR_PASSWORD=password
ENV MICA_ANONYMOUS_PASSWORD=password
ENV MICA_HOME=/srv
ENV JAVA_OPTS=-Xmx2G

# Install Mica
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https && \
  echo 'deb https://obiba.jfrog.io/obiba/debian-local all main' | tee /etc/apt/sources.list.d/obiba.list && \
  echo mica-server mica-server/admin_password select password | debconf-set-selections && \
  echo mica-server mica-server/admin_password_again select password | debconf-set-selections && \
  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --allow-unauthenticated mica2 mica-python-client

RUN chmod +x /usr/share/mica2/bin/mica2

COPY bin /opt/mica/bin

RUN chmod +x -R /opt/mica/bin
RUN chown -R mica /opt/mica

VOLUME /srv

# http and https
EXPOSE 8082 8445

# Define default command.
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["app"]
