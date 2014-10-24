#
# Docker helper
#

help:
	@echo "make build run-mongodb run stop clean"

# List Docker images
images:
	sudo docker images

#
# Mica
#

# Build Mica Docker image
build:
	sudo docker build -t="obiba/mica:snapshot" .

# Run a Mica Docker instance
run-default:
	sudo docker run -d -p 8845:8445 --name mica --link mongodb:mongodb --link opal:opal obiba/mica:snapshot

# Run a Mica Docker instance with database setup
run:
	sudo docker run -d -p 8845:8445 --name mica --link mongodb:mongodb --link opal:opal -v `pwd`/data:/data obiba/mica:snapshot bash start.sh

# Run a Mica Docker instance with shell
run-sh:
	sudo docker run -ti -p 8845:8445 --name mica --link mongodb:mongodb --link opal:opal -v `pwd`/data:/data obiba/mica:snapshot bash

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