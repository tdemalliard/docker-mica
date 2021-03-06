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

ENV MICA_VERSION 1.5.1

# Install Mica Python Client
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https unzip

RUN \
  wget -q -O - https://pkg.obiba.org/obiba.org.key | apt-key add - && \
  echo 'deb https://pkg.obiba.org stable/' | tee /etc/apt/sources.list.d/obiba.list && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y mica-python-client=$(apt-cache madison mica-python-client | cut -d ' ' -f 3 | grep ${MICA_VERSION})

# Install Mica Server
RUN set -x && \
  cd /usr/share/ && \
  wget -q -O mica2.zip http://download.obiba.org/mica/stable/mica2-${MICA_VERSION}-dist.zip && \
  unzip -q mica2.zip && \
  rm mica2.zip && \
  mv mica-dist-${MICA_VERSION} mica2

RUN chmod +x /usr/share/mica2/bin/mica2

COPY ./bin /opt/mica/bin

RUN chmod +x -R /opt/mica/bin
RUN adduser --system --home $MICA_HOME --no-create-home --disabled-password mica
RUN chown -R mica /opt/mica

VOLUME /srv

# http and https
EXPOSE 8082 8445

# Define default command.
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["app"]
