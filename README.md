# Docker MySQL 8.x Image (AMD64/ARM64)

The official MySQL repo image only supports AMD64 processors, and as Apple has introduced M1 chips (ARM64), I decided to build my own image so that dockerized apps that use MySQL can work without configuration changes on both the AMD64 and ARM64 processors.

This image inherits nearly all settings from the official docker [MySQL](https://hub.docker.com/_/mysql) image, 
but the `mysql_native_password authentication` plugin is enabled by default.

The root user is also granted permission to log in from any host e.g `@%` by default , so you can connect with [tableplus](https://tableplus.com) or similar database managers. You can change the host by setting the env var `MYSQL_ROOT_HOST`.

The default username is `root` and password is `root`, however you can change by setting the new password in the env var `MYSQL_ROOT_PASSWORD`.

If you want it to create a database then set `MYSQL_DATABASE` with the database name. The image will also create a new user for you if you supply both a `MYSQL_USER` and `MYSQL_PASSWORD`.  If you are creating both a user and database, then full permissions will be granted to the new user from any host.

### Docker Compose Service

To add as a service to your `docker-compose.yml`

```yaml
services:
  db:
    image: jamielsharief/mysql:latest
    volumes:
      - mysql-data:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=root
    ports:
      - "3307:3306"
```

### Container

To work with a normal container, remember you need to setup volumes so data is persisted.

```
$ docker build -t mysql .
```

To start a MySQL container with the username `root` and password `root`

```
$ docker run -it -d -p 3306:3306 mysql
```


To change the root password

```
$ docker run -it -p 3306:3306 -e MYSQL_ROOT_PASSWORD=foo mysql
```

To create a database

```
$ docker run -it -p 3306:3306 -e MYSQL_DATABASE=application mysql
```

To create a user you must supply both a username and password

```
$ docker run -it -p 3306:3306 -e MYSQL_USER=jon -e MYSQL_PASSWORD=secret mysql
```

If you are creating a user and a database, full permissions will be granted for that
user on that database.


Here is a full example

```
$ docker run -it -p 3306:3306 -e MYSQL_ROOT_PASSWORD=foo -e MYSQL_USER=roger -e MYSQL_PASSWORD=beck -e MYSQL_DATABASE=application mysql
```

## Resources

- [Github](https://github.com/jamielsharief/docker-mysql)
- [Docker Hub](https://hub.docker.com/r/jamielsharief/mysql)