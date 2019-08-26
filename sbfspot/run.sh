#!/bin/sh
set -e

# --- CREATE CRON ----


# --- GENERATE CONFIG --
./generateConfig.sh SBFspot.cfg SBFspotUpload.cfg

# ---- RUN ----
# cron
echo 'Starting cron in foreground'
/usr/sbin/crond -f

# echo 'Starting daemon'
# ./SBFspotUploadDaemon
