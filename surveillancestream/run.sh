#!/bin/bash
# config
echo 'Build config'
cat /data/options.json
CONFIG_PATH=/data/options.json
CONFIG_DB_URL="$(jq --raw-output '.db_url' $CONFIG_PATH)"
CONFIG_RECORDING_FOLDER="$(jq --raw-output '.recording_folder' $CONFIG_PATH)"

# echo "CONFIG_DB_URL=${CONFIG_DB_URL}"
# echo "CONFIG_RECORDING_FOLDER=${CONFIG_RECORDING_FOLDER}"

# ls -lah /opt/surveillancestream/

# create .env files
echo "db_url=${CONFIG_DB_URL}" > /opt/surveillancestream/backend/backend/prisma/.env

echo "recording_folder=${CONFIG_RECORDING_FOLDER}" > /opt/surveillancestream/backend/.env
# cat /opt/surveillancestream/backend/backend/prisma/.env
# cat /opt/surveillancestream/backend/.env

echo "REACT_APP_GQL_HOST=http://localhost:4000" > /opt/surveillancestream/frontend/.env
echo "REACT_APP_STATIC_HOST=http://localhost:3001" >> /opt/surveillancestream/frontend/.env
# cat /opt/surveillancestream/frontend/.env

# build backend
echo 'Build backend'
cd /opt/surveillancestream/backend && yarn run build

# build frontend
echo 'Build frontent'
cd /opt/surveillancestream/frontend && yarn run build && cd ..

echo 'Run'
# run
node /opt/surveillancestream/backend/dist/index.js
