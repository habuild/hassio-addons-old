ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# install requirements
RUN apk update && apk upgrade && apk add --no-cache jq git g++ make musl-dev mysql-dev bluez-dev boost boost-dev curl-dev

# download and buid SBFspot
RUN \
    cd /tmp \
    && git clone https://github.com/LauR3y/SBFspot.git . \
    && cd SBFspot \
    && make mysql \
    && cd .. \
    && cd SBFspotUploadDaemon \
    && make mysql

# Copy data for add-on
RUN cp /tmp/SBFspot/mysql/bin/SBFspot /
RUN cp /tmp/SBFspotUploadDaemon/mysql/bin/SBFspotUploadDaemon /
RUN cp /tmp/SBFspot/date_time_zonespec.csv /
run cp /tmp/SBFspot/TagList* /


COPY generateConfig.sh /
COPY run.sh /

RUN chmod a+x /run.sh /generateConfig.sh /SBFspot /SBFspotUploadDaemon

# install cron
RUN echo '*/5 * * * *   /SBFspot -v -finq' > /etc/crontabs/root

CMD [ "/run.sh" ]
