#!/usr/bin/env bash
   
	function getCurrentVersion(){
		CURRENT_PHP_VERSION="$(php -r "echo PHP_MAJOR_VERSION; echo '.'; echo PHP_MINOR_VERSION;")"
	}

	if [ -z "$1" ]
	  then
	    echo "Error: no version given"
		getCurrentVersion
	    echo ${CURRENT_PHP_VERSION}" process is running."
	    exit 0
	fi

	TO_PHP_VERSION="$1"

	if [ ! -d "/etc/php/$TO_PHP_VERSION" ]; then
	    echo "$TO_PHP_VERSION Version is not available!"
	    getCurrentVersion
	    echo ${CURRENT_PHP_VERSION}" process is running."
	    exit 0
	fi
	
	for PHP_VERSION_AVAIL in $(ls --format=single-column /etc/php); do

	    if [[ $PHP_VERSION_AVAIL == $TO_PHP_VERSION ]];
		then
			sudo update-alternatives --set php /usr/bin/php${TO_PHP_VERSION} &> /dev/null
			sudo a2enmod php${PHP_VERSION_AVAIL} &> /dev/null
		else	
			sudo a2dismod php${PHP_VERSION_AVAIL} &> /dev/null
		fi
	done

    sudo service apache2 restart &> /dev/null
    
 	servstat=$(sudo service apache2 status)

	if [[ $servstat == *"active (running)"* ]]; then
		getCurrentVersion
	  	echo "php ${CURRENT_PHP_VERSION} is running. enjoy!"
	else 
		echo "apache is not running."
	fi
    