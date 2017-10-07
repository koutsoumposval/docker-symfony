Docker Symfony Bootstrap template
==============

Create docker machine
--------------
Create a new `default` docker machine
```
make create_docker_machine
```

Build
--------------
Build images & launch project
```
make build
```

Update hosts:
* run `docker-machine default ip` to get your docker machine ip
* add `192.168.99.100 progect-name.dev` in `/etc/hosts`

Teardown
--------------
```
make teardown
```

Stop
--------------
```
make stop
```

Console
---------------
Run any symfony console command
```
make console ARGS=""
```

Composer
---------------
```
make composer_install
make composer_update
```

Tests
---------------
```
make test
make phpunit ARGS=""
```