#!/bin/sh
set -e

echo 'Show all runlevels and their services.'
rc-status -a

echo 'Show all services.'
rc-status -s

# --- GENERATE CONFIG --
./generateConfig.sh SBFspot.cfg SBFspotUpload.cfg

# ---- RUN ----
# start service
rc-service SBFspotUploadDaemon.service start

# cron
echo 'Starting cron in foreground'
/usr/sbin/crond -f

# echo 'Starting daemon'
# ./SBFspotUploadDaemon
