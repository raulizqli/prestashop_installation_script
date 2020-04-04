#! /bin/bash

# Installation directories
LOGFILE='log/install.log'
RESOURCESDIR='resources/'
TMPDIR='tmp/'
PSPACK=${RESOURCESDIR}'prestashop*.zip'
PSDIRUNPACK=${TMPDIR}'prestashop_pack/'
PSDIRSOURCEUNPACK=${PSDIRUNPACK}'prestashop_source/'
PSSOURCE=${PSDIRUNPACK}'prestashop.zip'
WWWDIR='/var/www/html/'
PSPRODDIR=${WWWDIR}'prestashop/'
PSINSTALLER=${PSPRODDIR}'install/index_cli.php'

# Configuration variables 
# a) Database
HOSTDOMAIN='localhost'
DBSERVER='localhost'
DBUSER='psuser'
DBPASSWORD='passw0rd'
DBNAME='db_mystore'
# b) Prestashop
PSUSERFIRSNAME='Bernardo'
PSUSERLASTNAME='Izquierdo'
PSPASSWORD='psdatamine'
PSEMAIL='bizquierdo@datamine.com.mx'

# They installed all packages needed
apt-get update
apt-get upgrade
apt-get install unzip
apt-get install apache2 
apt-get install mysql-server mysql-client mysql-common
apt-get install php7.2 libapache2-mod-php7.2 php7.2-cli php7.2-intl php7.2-json php7.2-curl php7.2-mysql php7.2-xml php7.2-gd php7.2-soap php7.2-zip
apt-get install php-dev libmcrypt-dev php-pear 

# Install mcript 
pecl channel-update pecl.php.net
pecl install mcrypt-1.0.1

# Add all extensions to php.ini
phpenmod mysqli
phpenmod curl
phpenmod gd
phpenmod soap
phpenmod xml
phpenmod simplexml
phpenmod pdo
phpenmod pdo_mysql
phpenmod curl
phpenmod zip
phpenmod intl

# Add mcrypt extension to php.ini
echo "extension=mcrypt.so" >> /etc/php/7.2/apache2/php.ini
echo "extension=mcrypt.so" >> /etc/php/7.2/cli/php.ini

# Enable mod_rewrite
a2enmod rewrite
a2dismod secutity
a2dismod auth_basic

# Restart apache server
/etc/init.d/apache2 restart

# Configure MySQL 
# Create access user and gran privileges 

mysql -u root -e "DROP USER '${DBUSER}'@'${DBSERVER}';"
mysql -u root -e "DROP DATABASE ${DBNAME};"
mysql -u root -e "CREATE DATABASE ${DBNAME};"
mysql -u root -e "CREATE USER '${DBUSER}'@'${DBSERVER}' IDENTIFIED BY '${DBPASSWORD}';"
mysql -u root -e "GRANT ALL PRIVILEGES ON ${DBNAME}.* TO '${DBUSER}'@'${DBSERVER}';"
mysql -u root -e "FLUSH PRIVILEGES;"

# Detele tmp unpack directory
rm -Rf $PSDIRPACK

# Unpack all installation PrestaShop directories 
unzip -u-v $PSPACK -d $PSDIRUNPACK 
unzip -u-v $PSSOURCE -d $PSDIRSOURCEUNPACK

# Install PrestaShop 

rm -Rf $PSPRODDIR
mv $PSDIRSOURCEUNPACK $PSPRODDIR
chown -Rf www-data:www-data $PSPRODDIR
chmod -Rf 755 $PSPRODDIR

#php $PSINSTALLER --domain=$HOSTDOMAIN --db_server=$DBSERVER --db_user=$DBUSER --db_password=$DBPASSWORD --db_name=$DBNAME --prefix=tbl_ --contry=mx --firsname=$PSUSERFIRSNAME --lastname=$PSUSERLASTNAME --password=$PSPASSWORD --email=$PSEMAIL

#php tmp/prestashop_pack/prestashop_source/install/index_cli.php --domain=localhost --db_server=localhost --db_user=psuser --db_password=psdatamine --db_name=db_psdatamine --prefix=tbl_ --contry=mx --firsname=Bernardo --lastname=Izquierdo --password=psdatamine --email=bizquierdo@datamine.com.mx 
