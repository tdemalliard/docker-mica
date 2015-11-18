#!/bin/bash

# Check if 1st run. Then configure database.
if [ -e /opt/mica/bin/first_run.sh ]
    then
    /opt/mica/bin/first_run.sh
    mv /opt/mica/bin/first_run.sh /opt/mica/bin/first_run.sh.done
fi

# Wait for MongoDB to be ready
until curl -i http://$MONGO_PORT_27017_TCP_ADDR:$MONGO_PORT_27017_TCP_PORT/mica &> /dev/null
do
  sleep 1
done

# Start service
service mica2 start

# Wait for service to be ready
until ls /var/log/mica2/mica.log &> /dev/null
do
	sleep 1
done

# Tail the log
tail -f /var/log/mica2/mica.log

# Stop service
service mica2 stop