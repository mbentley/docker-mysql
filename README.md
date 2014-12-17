mbentley/mysql
==================

docker image for mysql 5.5
based off of stackbrew/debian:jessie

To pull this image:
`docker pull mbentley/mysql`

Example usage:
`docker run -i -t -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=docker mbentley/mysql`

`docker run -i -t -d -p 3306:3306 -v /data/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=docker -e MYSQL_DATABASE=docker -e MYSQL_USER=user1 -e MYSQL_PASSWORD=pass1 mbentley/mysql`


The following environment variables can be passed to the docker image:

`MYSQL_ROOT_PASSWORD` (default: docker)

`MYSQL_DATABASE` (default: <blank>; if left blank, it will not create a database)

`MYSQL_USER` (default: <blank>; if left blank, it will not create a user account)

`MYSQL_PASSWORD` (default: <blank>; if left blank, it will not set a user password)

`MYSQLD_ARGS` (default: --skip-name-resolve)
