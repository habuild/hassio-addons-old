ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# install requirements
RUN apk update && apk upgrade && apk add --no-cache jq git g++ make musl-dev mysql-dev bluez-dev boost boost-dev curl-dev openrc

# openrc changes
RUN \
    # Tell openrc its running inside a container, till now that has meant LXC
        sed -i 's/#rc_sys=""/rc_sys="lxc"/g' /etc/rc.conf &&\
    # Tell openrc loopback and net are already there, since docker handles the networking
        echo 'rc_provide="loopback net"' >> /etc/rc.conf &&\
    # no need for loggers
        sed -i 's/^#\(rc_logger="YES"\)$/\1/' /etc/rc.conf &&\
    # can't get ttys unless you run the container in privileged mode
        sed -i '/tty/d' /etc/inittab &&\
    # can't set hostname since docker sets it
        sed -i 's/hostname $opts/# hostname $opts/g' /etc/init.d/hostname &&\
    # can't mount tmpfs since not privileged
        sed -i 's/mount -t tmpfs/# mount -t tmpfs/g' /lib/rc/sh/init.sh &&\
    # can't do cgroups
        sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh

RUN rc-status
RUN mkdir -p /run/openrc && touch /run/openrc/softlevel

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
COPY openrc-restart-crashed.sh /
COPY SBFspotUploadDaemon.service /etc/init.d/SBFspotUploadDaemon.service
COPY run.sh /

# load volume
VOLUME [ "/sys/fs/cgroup" ]

RUN chmod a+x /run.sh /generateConfig.sh /openrc-restart-crashed.sh /SBFspot /SBFspotUploadDaemon /etc/init.d/SBFspotUploadDaemon.service

# --- install cron ---
# set shell
RUN echo 'SHELL=/bin/bash' > /etc/crontabs/root
# daily data SBFspot
RUN echo '*/5 6-22 * * *    /SBFspot -v -ad1 -am0 -ae0 > /dev/stdout' >> /etc/crontabs/root
# monthly data SBFspot
RUN echo '55 05 * * *       /SBFspot -v -sp0 -ad0 -am1 -ae1 -finq > /dev/stdout' >> /etc/crontabs/root
# openrc restart crashed services
RUN echo '*/15 * * * *       /openrc-restart-crashed.sh -- SBFspotUploadDaemon.service > /dev/stdout' >> /etc/crontabs/root
# openrc status logging
##RUN echo '*/5 * * * *       rc-status -s > /dev/stdout' >> /etc/crontabs/root

# install service
RUN rc-update add SBFspotUploadDaemon.service default

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
