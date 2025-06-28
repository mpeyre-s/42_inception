#!/bin/bash

cd /var/www/wordpress

echo "Testing database connection..."
echo "    - User: $MYSQL_USER"
echo "    - Database: $MYSQL_DATABASE"
echo "    - Host: $MYSQL_HOST"

until mysqladmin -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" ping &>/dev/null; do
    echo "Waiting for MariaDB... (Trying to connect as $MYSQL_USER)"
    sleep 5
done

echo "Database connection successful!"

if [ ! -f wp-config.php ]; then
	echo "Creating wp-config.php..."

	wp config create \
		--dbname="$MYSQL_DATABASE" \
		--dbuser="$MYSQL_USER" \
		--dbpass="$MYSQL_PASSWORD" \
		--dbhost=mariadb \
		--path=/var/www/wordpress \
		--allow-root

	wp core install \
		--url="$DOMAIN_NAME" \
		--title="Inception" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--skip-email \
		--allow-root

	wp user create "$WP_USER" "$WP_USER_EMAIL" \
		--role=author \
		--user_pass="$WP_USER_PASSWORD" \
		--allow-root

	echo "WordPress successfully installed."
else
	echo "WordPress is already configured."
fi

echo "Launching PHP-FPM..."
exec /usr/sbin/php-fpm7.4 -F
