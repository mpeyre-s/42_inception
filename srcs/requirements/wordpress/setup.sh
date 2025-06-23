#!/bin/sh
set -e

echo "Waiting for MySQL to be available..."
while ! mysqladmin ping -h mariadb -u ${MYSQL_USER} -p${MYSQL_PASSWORD} --silent; do
    sleep 1
done
echo "MySQL is available, proceeding with WordPress setup"

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
	--skip-email \
        --allow-root

    wp user create "$WP_USER" "$WP_USER_EMAIL" \
	--role=author \
	--user_pass="$WP_USER_PASSWORD" \
	--allow-root
fi

php_fpm_executable=$(which php-fpm)
echo "Starting PHP-FPM: $php_fpm_executable"

exec $php_fpm_executable -F
