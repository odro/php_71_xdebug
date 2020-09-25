FROM php:7.1-apache

ENV APACHE_DOCUMENT_ROOT /var/www/html/public

RUN a2enmod rewrite

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get clean -y && \
    rm -fr /var/lib/apt/lists/*
RUN mkdir /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
RUN docker-php-ext-install mysqli pdo_mysql

# Add xdebug, borrowed from https://hub.docker.com/r/phpstorm/php-71-apache-xdebug/dockerfile
RUN pecl install xdebug-2.6.0 &&  docker-php-ext-enable xdebug && \
echo "xdebug.remote_enable=1" >> /usr/local/etc/php/php.ini && \
# Make xdebug work on OS X
echo "xdebug.remote_host=host.docker.internal" >> /usr/local/etc/php/php.ini && \
echo "xdebug.remote_connect_back=Off" >> /usr/local/etc/php/php.ini