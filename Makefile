DOCKER_COMPOSE = docker-compose -f docker/docker-compose.yml
COMPOSER = docker run --rm -u $(shell id -u) -v $(shell pwd):/app composer/composer

ARGS?=""

.PHONY: create_docker_machine build teardown test phpunit console composer_install composer_update

create_docker_machine:
	docker-machine create default --driver virtualbox --virtualbox-memory 4096 --virtualbox-disk-size "60000" \
		--virtualbox-boot2docker-url https://github.com/boot2docker/boot2docker/releases/download/v1.13.1/boot2docker.iso
	docker-machine-nfs default --nfs-config="-alldirs -maproot=0" --mount-opts="noacl,async,nolock,vers=3,udp,noatime,actimeo=1"
	docker-machine ssh default "echo sysctl -w vm.max_map_count=262144 | sudo tee -a /var/lib/boot2docker/bootlocal.sh"
	docker-machine ssh default sudo /var/lib/boot2docker/bootlocal.sh

build:
	${DOCKER_COMPOSE} build
	${DOCKER_COMPOSE} up -d
	$(MAKE) composer_install

teardown:
	${DOCKER_COMPOSE} down --volumes --remove-orphans

test:
	${DOCKER_COMPOSE} exec -T application "vendor/bin/phpunit"
	${DOCKER_COMPOSE} exec -T application phpcs src --standard=PSR2

phpunit:
	${DOCKER_COMPOSE} exec application vendor/bin/phpunit ${ARGS}

console:
	${DOCKER_COMPOSE} exec -T application bin/console ${ARGS}

composer_install:
	${COMPOSER} install

composer_update:
	${COMPOSER} update