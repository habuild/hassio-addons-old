ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# install requirements
RUN apk update && apk upgrade && apk add --no-cache jq g++ make musl-dev mysql-dev bluez-dev boost boost-dev curl-dev

# download and buid SBFspot
RUN cd /tmp\
    && git clone https://github.com/LauR3y/SBFspot.git sbfspot\
    && cd sbfspot/SBFspot\
    && make mysql\
    && cd ../SBFspotUploadDaemon\
    && make mysql\

# Copy data for add-on
COPY /tmp/sbfspot/SBFspot/mysql/bin/SBFspot /
COPY /tmp/sbfspot/SBFspotUploadDaemon/mysql/bin/SBFspotUploadDaemon /
COPY /tmp/sbfspot/SBFspot/date_time_zonespec.csv /
COPY /tmp/sbfspot/SBFspot/TagList* /

COPY generateConfig.sh /
COPY run.sh /

RUN chmod a+x /run.sh /generateConfig.sh /SBFspot /SBFspotUploadDaemon

CMD [ "/run.sh" ]
