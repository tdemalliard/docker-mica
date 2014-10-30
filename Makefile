#
# Docker helper
#

no_cache=false

help:
	@echo "make build run-mongodb run stop clean"

#
# Mica
#

# Build Mica Docker image
build:
	sudo docker build --no-cache=$(no_cache) -t="obiba/mica:snapshot" .

# Run a Mica Docker instance
run:
	sudo docker run -d -p 8845:8445 -p 8882:8082 --name mica --link mongodb:mongodb --link opal:opal obiba/mica:snapshot

# Run a Mica Docker instance with shell
run-sh:
	sudo docker run -ti -p 8845:8445 -p 8882:8082 --name mica --link mongodb:mongodb --link opal:opal obiba/mica:snapshot bash

# Show logs
logs:
	sudo docker logs mica

# Stop a Mica Docker instance
stop:
	sudo docker stop mica

# Stop and remove a Mica Docker instance
clean: stop
	sudo docker rm mica

#
# MongoDB
#

# Run a Mongodb Docker instance
run-mongodb:
	sudo docker run -d --name mongodb dockerfile/mongodb

# Stop a Mongodb Docker instance
stop-mongodb:
	sudo docker stop mongodb

# Stop and remove a Mongodb Docker instance
clean-mongodb: stop-mongodb
	sudo docker rm mongodb