server {
    listen {{ .interface }}:{{ .port }} default_server;

    include /etc/nginx/includes/server_params.conf;
    include /etc/nginx/includes/proxy_params.conf;

    location /graphql {
        allow   172.30.32.2;
        deny    all;

        proxy_pass http://backend;
    }

    location / {
        allow   172.30.32.2;
        deny    all;

        proxy_pass http://frontend;

        sub_filter '/_next' '%%INGRESS_ENTRY%%/_next';
        sub_filter '/graphql' '%%INGRESS_ENTRY%%/graphql';
    }
}
