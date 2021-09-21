#!/usr/bin/env bashio
# config
echo 'Build config'
cat /data/options.json
# CONFIG_PATH=/data/options.json
CONFIG_DATABASE_HOST=$(bashio::config 'DATABASE_HOST') # "$(jq --raw-output '.DATABASE_HOST' $CONFIG_PATH)"
CONFIG_DATABASE_PORT=$(bashio::config 'DATABASE_PORT') # "$(jq --raw-output '.DATABASE_PORT' $CONFIG_PATH)"
CONFIG_DATABASE_USER=$(bashio::config 'DATABASE_USER') # "$(jq --raw-output '.DATABASE_USER' $CONFIG_PATH)"
CONFIG_DATABASE_PASS=$(bashio::config 'DATABASE_PASS') # "$(jq --raw-output '.DATABASE_PASS' $CONFIG_PATH)"
CONFIG_DATABASE_NAME=$(bashio::config 'DATABASE_NAME') # "$(jq --raw-output '.DATABASE_NAME' $CONFIG_PATH)"
CONFIG_SSL=$(bashio::config 'SSL') # "$(jq --raw-output '.SSL' $CONFIG_PATH)"

# echo "CONFIG_DB_URL=${CONFIG_DB_URL}"
# echo "CONFIG_RECORDING_FOLDER=${CONFIG_RECORDING_FOLDER}"

# ls -lah /opt/surveillancestream/

# create .env files
echo "DATABASE_HOST=${CONFIG_DATABASE_HOST}" > /opt/surveillancestream/backend/.env
echo "DATABASE_PORT=${CONFIG_DATABASE_PORT}" >> /opt/surveillancestream/backend/.env
echo "DATABASE_USER=${CONFIG_DATABASE_USER}" >> /opt/surveillancestream/backend/.env
echo "DATABASE_PASS=${CONFIG_DATABASE_PASS}" >> /opt/surveillancestream/backend/.env
echo "DATABASE_NAME=${CONFIG_DATABASE_NAME}" >> /opt/surveillancestream/backend/.env
echo "SSL=${CONFIG_SSL}" >> /opt/surveillancestream/backend/.env

# cat /opt/surveillancestream/backend/backend/prisma/.env
# cat /opt/surveillancestream/backend/.env

echo $(bashio::info);

 echo "SSL=${CONFIG_SSL}" > /opt/surveillancestream/frontend/.env

if $CONFIG_SSL
then
    echo "NEXT_PUBLIC_GQL_HOST=https://$(bashio::info.hostname):3000" > /opt/surveillancestream/frontend/.env
    echo "NEXT_PUBLIC_ASSET_PREFIX=http://$(bashio::info.hostname):3001" >> /opt/surveillancestream/frontend/.env
else
    echo "NEXT_PUBLIC_GQL_HOST=http://$(bashio::info.hostname):3000" > /opt/surveillancestream/frontend/.env
    echo "NEXT_PUBLIC_ASSET_PREFIX=http://$(bashio::info.hostname):3001" >> /opt/surveillancestream/frontend/.env
fi

# cat /opt/surveillancestream/frontend/.env

# build backend
echo 'Build backend'
cd /opt/surveillancestream/backend && yarn run build

echo 'Sync db'
/opt/surveillancestream/backend/node_modules/.bin/ts-node /opt/surveillancestream/backend/src/tools/db-schema.ts

# build frontend
echo 'Build frontend'
cd /opt/surveillancestream/frontend && yarn run build

# back to root
cd ..

# run
echo 'Run'
cd /opt/surveillancestream/backend && yarn run start&
cd /opt/surveillancestream/frontend && yarn run start
