#!/bin/bash
# -----------------------------------------------------------------------------
# 
#
# Author:  Samuel Taylor
# Updated: 18/02/1989
# -----------------------------------------------------------------------------
USE_S3="false"
ACCESS_KEY=""
SECRET_KEY=""
BUCKET=""

#if [ -z "$VIRTUAL_HOST" ]
#then
#    echo "VIRTUAL_HOST Must be defined"
#    exit 1
#fi

if [ -z "$TIME_ZONE" ]
then
    echo "  ** TIME_ZONE not defined, defaulting to UTC"
    TIME_ZONE="UTC"
fi

if [ -z "$LANG" ]
then
        echo "  ** LANG not defined, defaulting to en"
        LANG="en"
fi

CRYPT_KEY=`hostname | md5sum | cut -f 1 -d ' '`

if [ "$USE_S3" == "true" ]
then
    echo "  ** S3 support wip disabled"
    
        exit 1
fi

if [ ! -e '/app/solder/app/config/app.php' ]; then
    echo "  ** Copying default app config file"
    cp /app/default.app.php /app/solder/app/config/app.php
    chown www-data:www-data /app/solder/app/config/app.php
    sed -i s/VIRTUAL_HOST/${VIRTUAL_HOST}/g /app/solder/app/config/app.php
    sed -i s/TIME_ZONE/${TIME_ZONE}/g /app/solder/app/config/app.php
    sed -i s/LANG/${LANG}/g /app/solder/app/config/app.php
    sed -i s/SUPASECRT/${CRYPT_KEY}/g /app/solder/app/config/app.php
fi

if [ ! -e '/app/solder/app/config/database.php' ]; then
    echo "  ** Copying default database config file"
    cp /app/default.database.php /app/solder/app/config/database.php
    chown www-data:www-data /app/solder/app/config/database.php
    sed -i s/DB_NAME/${DB_NAME}/g /app/solder/app/config/database.php
    sed -i s/DB_USER/${DB_USER}/g /app/solder/app/config/database.php
    sed -i s/DB_PASSWORD/${DB_PASSWORD}/g /app/solder/app/config/database.php
fi

if [ ! -e '/app/solder/app/config/solder.php' ]; then
    echo "  ** Copying default solder config file"
    cp /app/default.solder.php /app/solder/app/config/solder.php
    chown www-data:www-data /app/solder/app/config/solder.php
    sed -i s,MIRROR_URL,${MIRROR_URL},g /app/solder/app/config/solder.php
    sed -i s/USE_S3/${USE_S3}/g /app/solder/app/config/solder.php
    sed -i s/ACCESS_KEY/${ACCESS_KEY}/g /app/solder/app/config/solder.php
    sed -i s/SECRET_KEY/${SECRET_KEY}/g /app/solder/app/config/solder.php
    sed -i s/BUCKET/${BUCKET}/g /app/solder/app/config/solder.php

fi

if [ ! -e '/data/files' ]; then
    echo "  ** Creating default data folder"
    mkdir -p /data/files
    chown -R www-data:www-data /data/files
fi

chmod -R 777 /app/solder/public
chmod -R 777 /app/solder/app/storage

cd /app/solder

php artisan -q -n migrate:install
php artisan -q -n migrate --force
