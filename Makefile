DOCKER_COMPOSE = docker-compose
DOCKER_EXEC = docker exec
COMPOSER = /usr/local/bin/composer

APP_CONTAINER = dockersymfony_app_1
PMA_CONTAINER = dockersymfony_phpmyadmin_1
DB_CONTAINER = dockersymfony_database_1

ARGS?=""

## APPLICATION ##
.PHONY: create_docker_machine launch stop teardown console composer_install composer_update

create_docker_machine:
	docker-machine create default --driver virtualbox --virtualbox-memory 4096 --virtualbox-disk-size "60000" \
		--virtualbox-boot2docker-url https://github.com/boot2docker/boot2docker/releases/download/v1.13.1/boot2docker.iso
	docker-machine-nfs default --nfs-config="-alldirs -maproot=0" --mount-opts="noacl,async,nolock,vers=3,udp,noatime,actimeo=1"
	docker-machine ssh default "echo sysctl -w vm.max_map_count=262144 | sudo tee -a /var/lib/boot2docker/bootlocal.sh"
	docker-machine ssh default sudo /var/lib/boot2docker/bootlocal.sh

launch:
	eval "$(docker-machine env default)"
	${DOCKER_COMPOSE} up -d --build

stop:
	${DOCKER_COMPOSE} down

teardown:
	${DOCKER_COMPOSE} down --remove-orphans --volumes

console:
	${DOCKER_EXEC} -it ${APP_CONTAINER} bin/console ${ARGS}

composer_install:
	${COMPOSER} install

composer_update:
	${COMPOSER} update

## Tests ##
.PHONY: test phpunit

test: composer_install
	bin/test.sh

phpunit:
	vendor/bin/phpunit ${ARGS}