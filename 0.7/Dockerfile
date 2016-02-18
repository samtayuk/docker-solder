FROM samtayuk/nginx-php:php7
MAINTAINER Samuel Taylor "samtaylor.uk@gmail.com"

ENV SOLDER_VERSION 0.7.3.1

RUN curl -S https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

RUN cd /app && wget -qO- https://github.com/TechnicPack/TechnicSolder/archive/v$SOLDER_VERSION.tar.gz | tar xz \
	&& mv TechnicSolder-$SOLDER_VERSION solder \
    && cd /app/solder \
    && composer install --no-dev --no-interaction \
    && chown -R www-data:www-data /app/solder

COPY default.conf /etc/nginx/conf.d/