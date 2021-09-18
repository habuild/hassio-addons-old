ARG BUILD_FROM=hassioaddons/base:latest
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
    nodejs

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
    # && yarn run build \
    \
    && cd ..

# Copy data for add-on
COPY run.sh /opt/surveillancestream/run.sh
RUN chmod a+x /opt/surveillancestream/run.sh

CMD [ "/opt/surveillancestream/run.sh" ]
