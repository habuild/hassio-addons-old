#!/bin/sh
set -e

# --- CREATE CRON ----


# --- GENERATE CONFIG --
./generateConfig.sh SBFspot.cfg SBFspotUpload.cfg

# ---- RUN ----
# cron
/usr/sbin/crond -l 8

./SBFspotUploadDaemon
