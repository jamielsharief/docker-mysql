# Docker MySQL 8.0 Image (beta)

The official repo image does not work on M1 (ARM 64) chips, so I decided to build my own. This is for
development and should not be used in production, the root user is also granted access on '@%'.

Another key difference is, that `mysql_native_password authentication plugin` is configured to work out the
box.

### Docker Compose Service

To add as a service to your `docker-compose.yml`

```yaml
services:
  db:
    image: jamielsharief/mysql:0.1.0
    volumes:
      - mysql-data:/var/lib/mysql
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