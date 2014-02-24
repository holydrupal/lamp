#!/bin/bash

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
