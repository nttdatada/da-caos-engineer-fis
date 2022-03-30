

IMAGE_ID="da-engineer-tools"
TAG=1.0

build_image:
	@docker build docker/. -t $(IMAGE_ID):$(TAG)

run_bash:
	@docker run --rm -it \
		--volume $${PWD}:/app/ \
		--name $(IMAGE_ID) $(IMAGE_ID):$(TAG) /bin/bash
