#
# Docker helper
#

no_cache=false

# Build Docker image
build:
	sudo docker build --no-cache=$(no_cache) -t="obiba/mica:snapshot" .

build-version:
	sudo docker build --no-cache=$(no_cache) -t="obiba/mica:$(version)" $(version) 

build-branch:
	sudo docker build --no-cache=$(no_cache) -t="obiba/mica:branch-snapshot" branch-snapshot 
