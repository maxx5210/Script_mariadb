 #!/bin/bash

function help() {
echo "$0 [options]"
echo -e "Options :"
echo -e "\t -v : verbose"
echo -e "\t -p : install phpMyAdmin"
echo -e "\t -h --help : display this help"
echo -e "\nAuthors Thibaut.P Rémi.A"
}

function verbose() {
if [ "$verbose" = "true" ]
then
	echo -e $@
fi
}

function int_maria() {
verbose "Mise a jour des paquets"
apt-get update >> mariadb_install.log
verbose "Installation de mariaDB server"
apt-get install mariadb-server -y >> mariadb_install.log
}

function int_phpm() {
verbose "Mise a jour de la liste des paquets"
apt-get update >> mariadb_install.log
verbose "Installation de Apache"
apt-get install apache2 -y >> mariadb_install.log
verbose "Installation de php"
apt-get install libapache2-mod-php7.3 php7.3-mysql -y >> mariadb_install.log
verbose "Installation de unzip"
apt-get install unzip -y >> mariadb_install.log
tmpDir=$(mktemp -d)
cd $tmpDir
verbose "Téléchargement de phpMyAdmin"
wget -a mariadb_install.log --show-progress https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip
verbose "Extraction de l'archive de phpMyAdmin"
unzip phpMyAdmin-latest-all-languages.zip -d /var/www/html >> mariadb_install.log
mv /var/www/html/phpMyAdmin* /var/www/html/phpMyAdmin >> mariadb_install.log
chown -R www-data:www-data /var/www/html/phpMyAdmin >> mariadb_install.log
rm -r $tmpDir
}

iphpm="false"
verbose="false"

for var in $@
do
	case $var in
		-p)
			iphpm='true';;
		--help)
		;&
		-h)
			help
			exit;;
		-v)
			verbose='true';;
		*)
			echo "L'option $var n'existe pas"
			help
			exit;;
	esac
done

verbose ">Installation de mariaDB"
int_maria
verbose "<Installation de mariaDB"

if [ "$iphpm" = "true" ]
then
	verbose ">Installation de phpMyAdmin"
	int_phpm
	verbose "<Installation de phpMyAdmin"
fi

echo "Optionnel : executez mysql_secure_installation pour terminer la configuration de mariaDB"
