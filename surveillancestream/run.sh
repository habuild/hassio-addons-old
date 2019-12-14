# config
CONFIG_PATH=/data/options.json
CONFIG_DB_URL="$(jq --raw-output '.db_url' $CONFIG_PATH)"
CONFIG_RECORDING_FOLDER="$(jq --raw-output '.recording_folder' $CONFIG_PATH)"

echo "db_url=${CONFIG_DB_URL}" > /opt/surveillancestream/backend/.env
echo "recording_folder=${CONFIG_RECORDING_FOLDER}" >> /opt/surveillancestream/backend/.env \
echo "REACT_APP_GQL_HOST=http://localhost:4000" > /opt/surveillancestream/frontend/.env \
echo "REACT_APP_STATIC_HOST=http://localhost:3001" >> /opt/surveillancestream/frontend/.env

# build
cd backend && yarn run build && cd .. && cd frontent && yarn run build && cd ..

# run
node dist/index.js