FROM php:7.1-apache

MAINTAINER Chrysovalantis Koutsoumpos "info@newweb.gr"

# Extensions PHP
RUN apt-get update && apt-get install -y \
        curl \
        git \
        libicu-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo_mysql intl

# Conf apache
RUN a2enmod rewrite
COPY vhost.conf /etc/apache2/sites-enabled/000-default.conf

# Xdebug
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

# Install CodeSniffer
RUN pear install PHP_CodeSniffer-3.0.0RC3

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

WORKDIR /var/www/html

EXPOSE 80

ENTRYPOINT ["./docker/php-apache/entrypoint.sh"]

CMD ["apache2-foreground"]