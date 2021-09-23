#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: motionEye
# Configures NGINX for use with motionEye
# ==============================================================================

bashio::log.level 'all'
bashio::log.info 'run nginx.sh'
bashio::log.info "$(bashio::addons)"

IP_ADDRESS="$(bashio::addon.ip_address)"
INGRESS_PORT="$(bashio::addon.ingress_port)"

bashio::log.info $IP_ADDRESS
bashio::log.info $INGRESS_PORT

# Generate Ingress configuration
bashio::var.json \
    interface "$IP_ADDRESS" \
    port "$INGRESS_PORT" \
    | tempio \
        -template /etc/nginx/templates/ingress.gtpl \
        -out /etc/nginx/servers/ingress.conf

bashio::log.info bashio::config

# Generate direct access configuration, if enabled.
if bashio::var.has_value "$(bashio::addon.port 80)"; then
    bashio::config.require.ssl
    bashio::var.json \
        certfile "$(bashio::config 'certfile')" \
        keyfile "$(bashio::config 'keyfile')" \
        port "^$(bashio::addon.port 80)" \
        ssl "^$(bashio::config 'ssl')" \
        | tempio \
            -template /etc/nginx/templates/direct.gtpl \
            -out /etc/nginx/servers/direct.conf
fi