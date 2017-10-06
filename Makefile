DOCKER_COMPOSE=docker-compose

.PHONY: create_docker_machine
create_docker_machine:
	docker-machine create default --driver virtualbox --virtualbox-memory 4096 --virtualbox-disk-size "60000" \
		--virtualbox-boot2docker-url https://github.com/boot2docker/boot2docker/releases/download/v1.13.1/boot2docker.iso
	docker-machine-nfs default --nfs-config="-alldirs -maproot=0" --mount-opts="noacl,async,nolock,vers=3,udp,noatime,actimeo=1"
	docker-machine ssh default "echo sysctl -w vm.max_map_count=262144 | sudo tee -a /var/lib/boot2docker/bootlocal.sh"
	docker-machine ssh default sudo /var/lib/boot2docker/bootlocal.sh

.PHONY: launch
launch:
	eval "$(docker-machine env default)"
	${DOCKER_COMPOSE} up -d --build

.PHONY: stop
stop:
	${DOCKER_COMPOSE} down

.PHONY: teardown
teardown:
	${DOCKER_COMPOSE} down --remove-orphans --volumes

.PHONY: phpunit
phpunit: run
	${DOCKER_RUN} --network ${PROJECT}_default ${DOCKER_REGISTRY}/fxgp/php-ci vendor/bin/phpunit ${ARGS}
	$(MAKE) stop

