#!/bin/bash
set -e

chown -R mysql:mysql /var/lib/mysql
mysql_install_db --user mysql > /dev/null

MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-docker}
MYSQL_DATABASE=${MYSQL_DATABASE:-}
MYSQL_USER=${MYSQL_USER:-}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-}
MYSQLD_ARGS=${MYSQLD_ARGS:---skip-name-resolve}

temp_file=$(mktemp)
if [[ ! -f "${temp_file}" ]]; then
  exit 1
fi

cat << EOF > ${temp_file}
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
UPDATE user SET password=PASSWORD("${MYSQL_ROOT_PASSWORD}") WHERE user='root';
EOF

if [[ ${MYSQL_DATABASE} != "" ]]; then
  echo "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> ${temp_file}

  if [[ ${MYSQL_USER} != "" ]]; then
    echo "GRANT ALL ON \`${MYSQL_DATABASE}\`.* to '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" >> ${temp_file}
  fi
fi

/usr/sbin/mysqld --bootstrap --verbose=0 ${MYSQLD_ARGS} < ${temp_file}
rm -f ${temp_file}

exec /usr/sbin/mysqld ${MYSQLD_ARGS}
