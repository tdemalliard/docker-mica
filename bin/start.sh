# Configure MongoDB
sed s/localhost:27017/$MONGODB_PORT_28017_TCP_ADDR:$MONGODB_PORT_27017_TCP_PORT/g /etc/mica-server/application.yml > /tmp/application.yml
mv -f /tmp/application.yml /etc/mica-server/application.yml
# Configure Opal
sed s/localhost:8443/$OPAL_PORT_8443_TCP_ADDR:$OPAL_PORT_8443_TCP_PORT/g /etc/mica-server/application.yml > /tmp/application.yml
mv -f /tmp/application.yml /etc/mica-server/application.yml
chown -R mica-server:adm /etc/mica-server

# Start service
service mica-server start

# Wait for service to be ready
sleep 30

# Seed some studies
#mkdir -p /var/lib/mica-server/seed/in
#cd /var/lib/mica-server/seed/in
#wget https://raw.githubusercontent.com/obiba/mica-server/master/mica-core/src/test/resources/seed/studies.json
#cd /data
#chown -R mica-server:adm /var/lib/mica-server/seed

# Tail the log
tail -f /var/log/mica-server/stdout.log