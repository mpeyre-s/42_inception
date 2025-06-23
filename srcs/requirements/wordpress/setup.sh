#!/bin/sh
set -e

# create wordpress config (if unexisting)
if [ ! -f "/var/www/html/wp-config.php" ]; then
    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb \
        --path=/var/www/html \
        --allow-root

    wp core install \
        --url=$DOMAIN_NAME \
        --title="WordPress Site" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --path=/var/www/html \
        --allow-root

    wp user create \
        $WP_USER \
        $WP_USER_EMAIL \
        --user_pass=$WP_USER_PASSWORD \
        --path=/var/www/html \
        --allow-root
fi

# start php
exec php-fpm81 -F

