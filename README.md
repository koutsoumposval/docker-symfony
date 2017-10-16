Docker Symfony Bootstrap template
==============
* symfony 3.3
* php 7.1 - apache - xdebug, CodeSniffer
* mariadbr
* phpmyadmin

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
* add `192.168.99.100 project-name.dev` in `/etc/hosts`

Teardown
--------------
```
make teardown
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