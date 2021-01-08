#!/bin/bash
# 
# Docker MySQL Image that works on M1 chips
# Copyright 2021 Jamiel Sharief
#
cat <<EOF

    __  ___      _____ ____    __ 
   /  |/  /_  __/ ___// __ \  / / 
  / /|_/ / / / /\__ \/ / / / / /  
 / /  / / /_/ /___/ / /_/ / / /___
/_/  /_/\__, //____/\___\_\/_____/
       /____/                     

EOF

initialize() {

  DATADIR='/var/lib/mysql';

  if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
      MYSQL_ROOT_PASSWORD="root"
  fi

  echo "Initializing MySQL"
  echo "=================="
  echo  
  mkdir -p /var/lib/mysql
  chown -R mysql:mysql /var/lib/mysql

  mysqld --initialize-insecure --user=mysql

  # Start temporary server
  echo "> Starting temporary server";
  if ! mysqld --daemonize --skip-networking --user=mysql; then
    echo "Error starting mysqld"
    exit 1
  fi
  
  echo "> Setting root password";
  echo
  echo "Password: $MYSQL_ROOT_PASSWORD"
  mysql <<EOF
  ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
  GRANT ALL ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
  CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
	GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;
  FLUSH PRIVILEGES ;
EOF

  # work similar to official mysql docker image
  if [ -n "$MYSQL_DATABASE" ]; then
   echo "> Creating database $MYSQL_DATABASE";
     mysql -p"$MYSQL_ROOT_PASSWORD" <<< "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;";
  fi

  if [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_PASSWORD" ]; then
		echo "> Creating user";
    echo 
    echo "User: $MYSQL_USER"
    echo "Password: $MYSQL_PASSWORD"
    echo 

    mysql -p"$MYSQL_ROOT_PASSWORD" <<< "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"

    echo "> Granting permissions";
		if [ -n "$MYSQL_DATABASE" ]; then
         mysql -p"$MYSQL_ROOT_PASSWORD" <<< "GRANT ALL ON \`${MYSQL_DATABASE}\`.* TO '$MYSQL_USER'@'%';";
		fi
	fi

  # Shutdown temporary server
  echo "> Shutting down temporary server";
  if ! mysqladmin shutdown -uroot -p"$MYSQL_ROOT_PASSWORD"  ; then
      echo "Error shutting down mysqld"
      exit 1
  fi
  echo "> Complete";
}

if [ "$1" = 'mysqld' ]; then
  if [ ! -d "$DATADIR/mysql" ]; then
    initialize;
  fi
fi
exec "$@"