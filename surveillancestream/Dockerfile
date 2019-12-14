ARG BUILD_FROM=hassioaddons/debian-base
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION


USER root 

# Install git, gnupg2
RUN apt update && apt install -y git gnupg2

# Install yarn
RUN apt-get update && apt-get install -y curl apt-transport-https && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

# install node
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install -y nodejs

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
    && yarn install --verbose \
    # && yarn run build \
    \
    && cd .. \
    \
    && cd frontend \
    && yarn install --verbose \
    # && yarn run build \
    \
    && cd ..

# Copy data for add-on
COPY run.sh /opt/surveillancestream/run.sh
RUN chmod a+x /opt/surveillancestream/run.sh

CMD [ "/opt/surveillancestream/run.sh" ]