#!/bin/bash
set -e

FILE="LocalSettings.php"
if [ ! -f  ${FILE} ]; then
    php maintenance/install.php \
        --installdbpass "${MYSQL_ROOT_PASSWORD}" \
        --dbprefix "${WIKI_DB_PREFIX}" \
        --dbname "${MYSQL_DATABASE}" \
        --dbuser "${MYSQL_USER}" \
        --dbpass "${MYSQL_PASSWORD}" \
        --dbserver "mediawiki_database" \
        --dbtype mysql \
        --scriptpath "" \
        --pass "${WIKI_PASSWORD}" \
        "${WIKI_NAME}" "${WIKI_USER}"

    # Enable mediawiki extensions
    echo "wfLoadExtension( 'ParserFunctions' );" >> /var/www/html/LocalSettings.php
    echo "wfLoadExtension( 'SimpleMathJax' );" >> /var/www/html/LocalSettings.php
    echo "enableSemantics( '${WIKI_DOMAIN}' );" >> /var/www/html/LocalSettings.php

    # Offer a customization point to the end user
    echo "if(file_exists(\"\$IP/LocalSettings.local.php\")){include_once \"\$IP/LocalSettings.local.php\";}" >> /var/www/html/LocalSettings.php

    # Update the DB schema according to the LocalSettings
    php /var/www/html/maintenance/update.php --quick

else
    echo Installation already present, file ${FILE} was found
fi
