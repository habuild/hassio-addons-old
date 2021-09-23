ARG BUILD_FROM=ghcr.io/hassio-addons/base/armv7
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION


USER root 

# Install git, gnupg2
RUN apk add --no-cache --virtual .build-dependencies \
    git \
    yarn \
    nghttp2-dev \
    nodejs \
    nginx

WORKDIR /opt/surveillancestream

# pull repo
RUN \
    git clone https://github.com/LauR3y/surveillancestream.git .

# Config
# COPY config.sh /config.sh
# RUN chmod a+x /config.sh
# RUN /config.sh

# Build
RUN \
    cd backend \
    && yarn install --network-timeout 1000000 \
    # && yarn run build \
    \
    && cd .. \
    \
    && cd frontend \
    && yarn install --network-timeout 1000000 \
    # && yarn add @swc/core-linux-arm-gnueabihf \
    # && yarn run build \
    \
    && cd ..

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
# ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="laurens verschuere" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    # org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="laurens verschuere" \
    org.opencontainers.image.licenses="MIT" \
    # org.opencontainers.image.url="https://addons.community" \
    # org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    # org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}