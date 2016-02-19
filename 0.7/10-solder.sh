#!/bin/bash
# -----------------------------------------------------------------------------
# 
#
# Author:  Samuel Taylor
# Updated: 18/02/2016
# -----------------------------------------------------------------------------
USE_S3="false"
ACCESS_KEY=""
SECRET_KEY=""
BUCKET=""

if [ -z "$BASE_URL" ]
then
    echo "  ** BASE_URL Must be defined"
    exit 1
fi

if [ -z "$MIRROR_URL" ]
then
    echo "  ** MIRROR_URL not defined, defaulting to $BASE_URL/files"
    MIRROR_URL="$BASE_URL/files"
fi

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

if [ ! -e '/config/app.php' ]; then
    echo "  ** Copying default app config file"
    cp /app/default.app.php /config/app.php
    chown www-data:www-data /config/app.php
    sed -i s/BASE_URL/${BASE_URL}/g /config/app.php
    sed -i s/TIME_ZONE/${TIME_ZONE}/g /config/app.php
    sed -i s/LANG/${LANG}/g /config/app.php
    sed -i s/SUPASECRT/${CRYPT_KEY}/g /config/app.php
fi

if [ ! -e '/app/solder/app/config/app.php' ]; then
    echo "  ** Creating app.php link"
    ln -s /config/app.php /app/solder/app/config/app.php
fi

if [ ! -e '/config/database.php' ]; then
    echo "  ** Copying default database config file"
    cp /app/default.database.php /config/database.php
    chown www-data:www-data /config/database.php
    sed -i s/DB_NAME/${DB_NAME}/g /config/database.php
    sed -i s/DB_USER/${DB_USER}/g /config/database.php
    sed -i s/DB_PASSWORD/${DB_PASSWORD}/g /config/database.php
fi

if [ ! -e '/app/solder/app/config/database.php' ]; then
    echo "  ** Creating database.php link"
    ln -s /config/database.php /app/solder/app/config/database.php
fi

if [ ! -e '/config/solder.php' ]; then
    echo "  ** Copying default solder config file"
    cp /app/default.solder.php /config/solder.php
    chown www-data:www-data /config/solder.php
    sed -i s,MIRROR_URL,${MIRROR_URL},g /config/solder.php
    sed -i s/USE_S3/${USE_S3}/g /config/solder.php
    sed -i s/ACCESS_KEY/${ACCESS_KEY}/g /config/solder.php
    sed -i s/SECRET_KEY/${SECRET_KEY}/g /config/solder.php
    sed -i s/BUCKET/${BUCKET}/g /config/solder.php

fi

if [ ! -e '/app/solder/app/config/solder.php' ]; then
    echo "  ** Creating solder.php link"
    ln -s /config/solder.php /app/solder/app/config/solder.php
fi

if [ ! -e '/data/files' ]; then
    echo "  ** Creating default data folder"
    mkdir -p /data/files
    chown -R www-data:www-data /data/files
fi

if [ ! -e '/data/resources' ]; then
    echo "  ** Creating default resources folder"
    cp -r /app/resources /data/resources
    chown -R www-data:www-data /data/resources
fi

if [ ! -e '/app/solder/public/resources' ]; then
    echo "  ** Creating resources link"
    ln -s /data/resources /app/solder/public/resources
fi

chmod -R 777 /app/solder/public
chmod -R 777 /app/solder/app/storage

cd /app/solder

php artisan -q -n migrate:install
php artisan -q -n migrate --force
