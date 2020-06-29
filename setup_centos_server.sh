#!/bin/bash

sudo yum install -y epel-release
sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
sudo cp mariadb.repo /etc/yum.repos.d
sudo rpm -Uvh http://nginx.org/packages/centos/7/x86_64/RPMS/nginx-1.16.1-1.el7.ngx.x86_64.rpm
sudo yum install -y zip unzip git composer java-1.8.0-openjdk mariadb-server php php-fpm php-mysqlnd php-gd php-curl php-mbstring php-dom php-opcache php-soap --enablerepo=remi-php73
sudo systemctl enable nginx && sudo systemctl start nginx && sudo systemctl enable mariadb && sudo systemctl start mariadb && sudo systemctl enable php-fpm && sudo systemctl start php-fpm
mysqladmin -u root password root
sudo sed -i "$ a [mariadb] \nmax_allowed_packet=900M" /etc/my.cnf
sudo sed -i.bak s/'display_errors = Off'/'display_errors = On'/g /etc/php.ini
sudo sed -i.bak s/'display_startup_errors = Off'/'display_startup_errors = On'/g /etc/php.ini
sudo sed -i.bak s/'memory_limit = 128M'/'memory_limit = 900M'/g /etc/php.ini
sudo sed -i.bak s/'user = apache'/'user = centos'/g /etc/php-fpm.d/www.conf
sudo sed -i.bak s/'group = apache'/'group = centos'/g /etc/php-fpm.d/www.conf
sudo rm /etc/nginx/conf.d/default.conf
sudo cp nginx.conf /etc/nginx/conf.d
composer global require drush/drush
echo 'export PATH=$HOME/.config/composer/vendor/bin:$PATH' >> ~/.bash_profile
source ~/.bash_profile
sudo rpm -Uvh https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.3.2-x86_64.rpm
yes | sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install ingest-attachment
sudo systemctl enable elasticsearch && sudo systemctl start elasticsearch
sudo semanage permissive -a httpd_t
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp   
sudo firewall-cmd --reload
sudo cp /usr/share/zoneinfo/America/New_York /etc/localtime
sudo systemctl restart nginx && sudo systemctl restart mariadb && sudo systemctl restart php-fpm



# based on https://github.com/MariaDB/server/blob/5.5/scripts/mysql_secure_installation.sh
mysql -u root -proot <<EOF
UPDATE mysql.user SET Password=PASSWORD('root') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF






