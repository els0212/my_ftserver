FROM debian:buster

RUN apt update
RUN apt -y upgrade
RUN apt install -y vim wget
RUN apt install -y nginx openssl
RUN apt install -y php-fpm php-mbstring

# copy .sh files
RUN mkdir setup_files
WORKDIR setup_files

# setup mysql
COPY srcs/mysql_setup.sh .
RUN apt install -y mariadb-server mariadb-client php-mysql
RUN ["/bin/bash", "mysql_setup.sh"]

# setup ssl
COPY srcs/ssl_setup.sh .
RUN ["/bin/bash", "ssl_setup.sh"]
COPY srcs/default /etc/nginx/sites-available/

# setup phpmyadmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz &&\
tar -xvf phpMyAdmin-5.0.2-all-languages.tar.gz &&\
mv phpMyAdmin-5.0.2-all-languages phpmyadmin &&\
mv phpmyadmin /var/www/html
COPY srcs/config.inc.php /var/www/html/phpmyadmin
RUN service mysql start &&\
		mysql < /var/www/html/phpmyadmin/sql/create_tables.sql

# setup wordpress
RUN wget https://wordpress.org/latest.tar.gz &&\
tar -xvf latest.tar.gz &&\
mv wordpress /var/www/html/ &&\
chown -R www-data:www-data /var/www/html/wordpress
COPY srcs/wp-config.php /var/www/html/wordpress/

EXPOSE 80 443

COPY srcs/start.sh .
ENTRYPOINT /bin/bash start.sh
