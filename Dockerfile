#
# Mica Dockerfile
#
# https://github.com/obiba/docker-mica
#

# Pull base image
FROM java:8

MAINTAINER OBiBa <dev@obiba.org>

ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

# Install Mica
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https && \
  wget -q -O - https://pkg.obiba.org/obiba.org.key | apt-key add - && \
  echo 'deb https://pkg.obiba.org unstable/' | tee /etc/apt/sources.list.d/obiba.list && \
  echo mica-server mica-server/admin_password select password | debconf-set-selections && \
  echo mica-server mica-server/admin_password_again select password | debconf-set-selections && \
  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y mica2 mica-python-client

COPY bin /opt/mica/bin

RUN chmod +x -R /opt/mica/bin

# Define default command.
ENTRYPOINT ["bash", "-c", "/opt/mica/bin/start.sh"]

# http and https
EXPOSE 8082 8445
