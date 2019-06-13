#!/bin/sh
set -e

# --- GENERATE CONFIG --
./generateConfig.sh SBFspot.cfg SBFspotUpload.cfg

# ---- RUN ----
# SBFspot
./SBFspot -v -finq -nocsv

# SBFspotUploadDaemon
./SBFspotUploadDaemon

