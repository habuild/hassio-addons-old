server {
    {{ if not .ssl }}
    listen {{ .port }} default_server;
    {{ else }}
    listen {{ .port }} default_server ssl http2;
    {{ end }}

    include /etc/nginx/includes/server_params.conf;
    include /etc/nginx/includes/proxy_params.conf;

    {{ if .ssl }}
    include /etc/nginx/includes/ssl_params.conf;

    ssl_certificate /ssl/{{ .certfile }};
    ssl_certificate_key /ssl/{{ .keyfile }};
    {{ end }}

    location /graphql {
        proxy_pass http://backend;
    }

    location / {
        proxy_pass http://frontend;

        sub_filter '/_next' '%%INGRESS_ENTRY%%/_next';
        sub_filter '/graphql' '%%INGRESS_ENTRY%%/graphql';
        sub_filter_once off;
    }
}