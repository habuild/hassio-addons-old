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
RUN echo '*/5 * * * *   /SBFspot -v -finq > /dev/stdout' > /etc/crontabs/root

# Labels
LABEL \
    io.hass.name="SBFspot" \
    io.hass.description="SBFspot, formerly known as SMAspot, is an open source project to get actual and archive data out of an SMA® inverter over Bluetooth or Ethernet (Speedwire®)" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Laurens Verschuere <hassio@laurensverschuere.be>" \
    org.label-schema.description="SBFspot, formerly known as SMAspot, is an open source project to get actual and archive data out of an SMA® inverter over Bluetooth or Ethernet (Speedwire®)" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="SBFspot" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://github.com/LauR3y/hassio-addons/tree/master/sbfspot" \
    org.label-schema.usage="https://github.com/LauR3y/hassio-addons/tree/master/sbfspot/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/LauR3y/hassio-addons" \
    org.label-schema.vendor="Laurens Verschuere"


CMD [ "/run.sh" ]
