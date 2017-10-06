<?php

putenv('ADMIN_DB_DRIVER=pdo_mysql');
putenv('ADMIN_DB_HOST=mysql');
putenv('ADMIN_DB_NAME=root');
putenv('ADMIN_DB_PASSWORD=password');
putenv('ADMIN_DB_PORT=3306');
putenv('ADMIN_DB_USER=root');
putenv('SYMFONY_ENV=test');
putenv('APP_ENV=test');

require_once  __DIR__.'/../vendor/autoload.php';
