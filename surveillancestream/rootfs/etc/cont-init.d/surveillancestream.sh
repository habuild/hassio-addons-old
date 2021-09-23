#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: surveillancestream
# Creates initial surveillancestream configuration in case it is non-existing
# ==============================================================================
# config
bashio::log.info "Build config"

CONFIG_DATABASE_HOST=$(bashio::config 'db_host') # "$(jq --raw-output '.DATABASE_HOST' $CONFIG_PATH)"
CONFIG_DATABASE_PORT=$(bashio::config 'db_port') # "$(jq --raw-output '.DATABASE_PORT' $CONFIG_PATH)"
CONFIG_DATABASE_USER=$(bashio::config 'db_username') # "$(jq --raw-output '.DATABASE_USER' $CONFIG_PATH)"
CONFIG_DATABASE_PASS=$(bashio::config 'db_password') # "$(jq --raw-output '.DATABASE_PASS' $CONFIG_PATH)"
CONFIG_DATABASE_NAME=$(bashio::config 'db_name') # "$(jq --raw-output '.DATABASE_NAME' $CONFIG_PATH)"
#CONFIG_SSL=$(bashio::config 'SSL') # "$(jq --raw-output '.SSL' $CONFIG_PATH)"

# create .env files
echo "DATABASE_HOST=${CONFIG_DATABASE_HOST}" > /opt/surveillancestream/backend/.env
echo "DATABASE_PORT=${CONFIG_DATABASE_PORT}" >> /opt/surveillancestream/backend/.env
echo "DATABASE_USER=${CONFIG_DATABASE_USER}" >> /opt/surveillancestream/backend/.env
echo "DATABASE_PASS=${CONFIG_DATABASE_PASS}" >> /opt/surveillancestream/backend/.env
echo "DATABASE_NAME=${CONFIG_DATABASE_NAME}" >> /opt/surveillancestream/backend/.env
echo "SSL=false" >> /opt/surveillancestream/backend/.env

echo "NEXT_PUBLIC_GQL_HOST=http://$(bashio::info.hostname):3000" > /opt/surveillancestream/frontend/.env
echo "SSL=false" >> /opt/surveillancestream/frontend/.env

bashio::log.info "Build backend"
cd /opt/surveillancestream/backend && yarn run build

bashio::log.info "Sync db"
/opt/surveillancestream/backend/node_modules/.bin/ts-node /opt/surveillancestream/backend/src/tools/db-schema.ts

bashio::log.info "Build frontend"
cd /opt/surveillancestream/frontend && yarn run build
