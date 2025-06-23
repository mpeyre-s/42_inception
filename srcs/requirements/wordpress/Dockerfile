FROM debian:oldstable

RUN apt-get update && apt-get install -y \
    php-fpm php-mysql php-json php-curl \
    php-dom php-exif php-fileinfo php-gd \
    php-iconv php-mbstring php-imagick \
    php-simplexml php-soap php-xml \
    php-xmlreader php-zip wget curl less mariadb-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php && \
    echo "PHP-FPM path: $(which php-fpm)"

RUN mkdir -p /var/www/html

RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    mv wordpress/* /var/www/html/ && \
    rm latest.tar.gz

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

RUN php_version=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;") && \
    mkdir -p /etc/php/$php_version/fpm/pool.d/

COPY www.conf /etc/php/*/fpm/pool.d/
COPY setup.sh /setup.sh

RUN chmod +x /setup.sh

ENTRYPOINT ["/setup.sh"]
CMD ["php-fpm", "-F"]
