FROM ubuntu:20.04

ENV DATE_TIMEZONE UTC
ENV DEBIAN_FRONTEND=noninteractive

RUN groupadd -r mysql && useradd -r -g mysql mysql

RUN apt-get update && apt-get install -y \
    mysql-server \
    mysql-client \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /var/lib/mysql \
 && mkdir -p /var/lib/mysql \
 && mkdir -p /var/run/mysqld \
 && chown -R mysql:mysql /var/lib/mysql \
 && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
 && chmod 1777 /var/run/mysqld \
 && chmod 1777 /var/lib/mysql

VOLUME /var/lib/mysql

COPY config/ /etc/mysql/

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 3306
CMD ["mysqld","--user=mysql"]