# Configure MongoDB
sed s/localhost:27017/$MONGO_PORT_28017_TCP_ADDR:$MONGO_PORT_27017_TCP_PORT/g /etc/mica2/application.yml > /tmp/application.yml
mv -f /tmp/application.yml /etc/mica2/application.yml
# Configure Opal
sed s/localhost:8443/$OPAL_PORT_8443_TCP_ADDR:$OPAL_PORT_8443_TCP_PORT/g /etc/mica2/application.yml > /tmp/application.yml
mv -f /tmp/application.yml /etc/mica2/application.yml
chown -R mica:adm /etc/mica2

# Start service
service mica2 start

# Wait for service to be ready
sleep 30

# Seed some studies
#mkdir -p /var/lib/mica2/seed/in
#cd /var/lib/mica2/seed/in
#wget https://raw.githubusercontent.com/obiba/mica2/master/mica-core/src/test/resources/seed/studies.json
#cd /data
#chown -R mica:adm /var/lib/mica2/seed

# Tail the log
tail -f /var/log/mica2/stdout.log