#
# Mica Dockerfile
#
# https://github.com/obiba/docker-mica
#

# Pull base image
FROM openjdk:8

MAINTAINER OBiBa <dev@obiba.org>

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.10
RUN set -x \
	&& wget -q -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -q -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true

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
  wget -q -O - https://pkg.obiba.org/obiba.org.key | apt-key add - && \
  echo 'deb https://pkg.obiba.org unstable/' | tee /etc/apt/sources.list.d/obiba.list && \
  echo mica-server mica-server/admin_password select password | debconf-set-selections && \
  echo mica-server mica-server/admin_password_again select password | debconf-set-selections && \
  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y mica2 mica-python-client

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