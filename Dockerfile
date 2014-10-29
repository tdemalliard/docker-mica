#
# Mica Dockerfile
#
# https://github.com/obiba/docker-mica
#

# Pull base image
FROM dockerfile/java:oracle-java8

MAINTAINER OBiBa <dev@obiba.org>

# Install Mica
RUN \
  wget -q -O - http://pkg.obiba.org/obiba.org.key | sudo apt-key add - && \
  echo 'deb http://pkg.obiba.org unstable/' | sudo tee /etc/apt/sources.list.d/obiba.list && \
  echo mica-server mica-server/admin_password select password | sudo debconf-set-selections && \
  echo mica-server mica-server/admin_password_again select password | sudo debconf-set-selections && \
  apt-get update && apt-get install -y mica-server mica-python-client

COPY bin /opt/mica/bin

RUN chmod +x -R /opt/mica/bin

# Define default command.
ENTRYPOINT ["bash", "-c", "/opt/mica/bin/start.sh"]

# https
EXPOSE 8445