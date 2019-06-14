#!/bin/sh
set -e

# --- CREATE CRON ----


# --- GENERATE CONFIG --
./generateConfig.sh SBFspot.cfg SBFspotUpload.cfg

# ---- RUN ----
# cron
echo 'Starting cron:'
/usr/sbin/crond -b -L /dev/stdout -l 8
echo 'Done.'

echo 'Starting daemon'
./SBFspotUploadDaemon
