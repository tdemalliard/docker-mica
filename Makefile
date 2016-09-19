#
# Docker helper
#

no_cache=false

# Build Docker image
build:
	sudo docker build --no-cache=$(no_cache) -t="obiba/mica:snapshot" .

build13:
	sudo docker build --no-cache=$(no_cache) -t="obiba/mica:1.3" 1.3 

build14x:
	sudo docker build --no-cache=$(no_cache) -t="obiba/mica:1.4-snapshot" 1.4-snapshot 
