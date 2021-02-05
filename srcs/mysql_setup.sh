#! /bin/bash

service mysql start
mysql -uroot -e "create user 'wordpress'@'%' identified by '1234'";
mysql -uroot -e "grant all privileges on *.* to 'wordpress' with grant option; flush privileges;"
mysql -uroot -e "create database wordpress;"
