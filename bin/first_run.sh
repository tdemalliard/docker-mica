#!/bin/bash

# Configure administrator password
adminpw=$(echo -n $MICA_ADMINISTRATOR_PASSWORD | xargs java -jar /usr/share/mica2-*/tools/lib/obiba-password-hasher-*-cli.jar)
cat /etc/mica2/shiro.ini | sed -e "s/^administrator\s*=.*,/administrator=$adminpw,/" > /tmp/shiro.ini && \
    mv /tmp/shiro.ini /etc/mica2/shiro.ini

# Configure MongoDB
sed s/localhost:27017/$MONGO_PORT_27017_TCP_ADDR:$MONGO_PORT_27017_TCP_PORT/g /etc/mica2/application.yml > /tmp/application.yml
mv -f /tmp/application.yml /etc/mica2/application.yml
# Configure Opal
sed s/localhost:8443/$OPAL_PORT_8443_TCP_ADDR:$OPAL_PORT_8443_TCP_PORT/g /etc/mica2/application.yml > /tmp/application.yml
mv -f /tmp/application.yml /etc/mica2/application.yml
# Configure Agate
sed s/localhost:8444/$AGATE_PORT_8444_TCP_ADDR:$AGATE_PORT_8444_TCP_PORT/g /etc/mica2/application.yml > /tmp/application.yml
mv -f /tmp/application.yml /etc/mica2/application.yml
chown -R mica:adm /etc/mica2