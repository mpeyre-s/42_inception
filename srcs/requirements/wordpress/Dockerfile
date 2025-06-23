FROM debian:oldstable

RUN apt-get update && apt-get install -y \
    php php-fpm php-mysql php-json php-curl \
    php-dom php-exif php-fileinfo php-gd \
    php-iconv php-mbstring  php-imagick \
    php-simplexml php-soap php-xml \
    php-xmlreader php-zip wget curl less mariadb-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html

RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    mv wordpress/* /var/www/html/ && \
    rm latest.tar.gz

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY www.conf /etc/php81/php-fpm.d/www.conf
COPY setup.sh /setup.sh

RUN chmod +x /setup.sh

ENTRYPOINT ["/setup.sh"]
CMD ["php-fpm81", "-F"]

