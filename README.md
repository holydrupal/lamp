LAMP Stack
==========

### lamp.sh
```bash
echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
DEBIAN_FRONTEND=noninteractive apt-get -y install \
mysql-client \
mysql-server \
apache2 \
libapache2-mod-php5 \
pwgen \
python-setuptools \
php5-mysql
```
### foreground.sh
```bash
read pid cmd state ppid pgrp session tty_nr tpgid rest < /proc/self/stat
trap "kill -TERM -$pgrp; exit" EXIT TERM KILL SIGKILL SIGTERM SIGQUIT
source /etc/apache2/envvars
apache2 -D FOREGROUND
```
### start.sh
```bash
if [ ! -f /mysql-configured ]; then
  echo "Configuring Password";
  /usr/bin/mysqld_safe &
  sleep 10s
  MYSQL_PASSWORD=`pwgen -c -n -1 12`
  echo mysql root password: $MYSQL_PASSWORD
  echo $MYSQL_PASSWORD > /mysql-root-pw.txt
  mysqladmin -u root password $MYSQL_PASSWORD
  touch /mysql-configured
  killall mysqld
  sleep 10s
fi
supervisord -n
```
### supervisord.conf
```
[unix_http_server]
file=/tmp/supervisor.sock   ; (the path to the socket file)
[supervisord]
logfile=/tmp/supervisord.log ; (main log file;default $CWD/supervisord.log)
logfile_maxbytes=50MB        ; (max main logfile bytes b4 rotation;default 50MB)
logfile_backups=10           ; (num of main logfile rotation backups;default 10)
loglevel=info                ; (log level;default info; others: debug,warn,trace)
pidfile=/tmp/supervisord.pid ; (supervisord pidfile;default supervisord.pid)
nodaemon=false               ; (start in foreground if true;default false)
minfds=1024                  ; (min. avail startup file descriptors;default 1024)
minprocs=200                 ; (min. avail process descriptors;default 200)
[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface
[supervisorctl]
serverurl=unix:///tmp/supervisor.sock ; use a unix:// URL  for a unix socket
[program:mysqld]
command=/usr/bin/mysqld_safe
[program:httpd]
command=/etc/apache2/foreground.sh
stopsignal=6
```
