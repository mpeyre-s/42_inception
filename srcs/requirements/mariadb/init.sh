#!/bin/bash

if [ -z "$SQL_DATABASE" ] || [ -z "$SQL_USER" ] || [ -z "$SQL_PASSWORD" ] || [ -z "$SQL_ROOT_PASSWORD" ]; then
    echo "ERROR: Missing environment variables"
    exit 1
fi

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Database initialization..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql --skip-test-db
fi

echo "Temporary launch of MariaDB in safe mode for configuration..."
mysqld_safe --datadir=/var/lib/mysql --skip-networking &
pid="$!"

until mysqladmin ping --silent; do
    sleep 1
done

echo "MariaDB is running"

echo "User and database configuration..."

mysql -uroot <<EOSQL
    -- Set root password
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}'
        PASSWORD EXPIRE NEVER
        ACCOUNT UNLOCK;

    CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;

    -- Recreate users to ensure correct password
    DROP USER IF EXISTS '${SQL_USER}'@'%';
    DROP USER IF EXISTS '${SQL_USER}'@'localhost';

    CREATE USER '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
    CREATE USER '${SQL_USER}'@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';

    GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';
    GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'localhost';

    DELETE FROM mysql.user WHERE User='';
    DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

    FLUSH PRIVILEGES;
EOSQL

cat > /tmp/mysqladmin.cnf << EOF
[client]
user=root
password=${SQL_ROOT_PASSWORD}
EOF

chmod 600 /tmp/mysqladmin.cnf

echo "Temporary stop of MariaDB..."
mysqladmin --defaults-file=/tmp/mysqladmin.cnf shutdown

rm /tmp/mysqladmin.cnf

echo "Final MariaDB startup..."
exec mysqld --user=mysql --console
