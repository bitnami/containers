# based on http://brainspl.at/nginx.conf.txt

{{#if NGINX_DAEMON_USER}}{{#if NGINX_DAEMON_GROUP}}
user {{NGINX_DAEMON_USER}} {{NGINX_DAEMON_GROUP}};
{{/if}}{{/if}}

worker_processes  auto;

error_log  "{{NGINX_LOGDIR}}/error.log";
pid        "{{NGINX_TMPDIR}}/nginx.pid";

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    add_header X-Frame-Options SAMEORIGIN;
    client_body_temp_path  "{{NGINX_TMPDIR}}/client_body" 1 2;
    proxy_temp_path "{{NGINX_TMPDIR}}/proxy" 1 2;
    fastcgi_temp_path "{{NGINX_TMPDIR}}/fastcgi" 1 2;
    scgi_temp_path "{{NGINX_TMPDIR}}/scgi" 1 2;
    uwsgi_temp_path "{{NGINX_TMPDIR}}/uwsgi" 1 2;

    log_format main '$remote_addr - $remote_user [$time_local] '
                    '"$request" $status  $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  "{{NGINX_LOGDIR}}/access.log";

    # no sendfile on OSX
    sendfile        on;

    tcp_nopush     on;
    tcp_nodelay       off;

    #keepalive_timeout  0;
    keepalive_timeout  65;
    gzip on;
    gzip_http_version 1.0;
    gzip_comp_level 2;
    gzip_proxied any;
    gzip_types text/plain text/css application/x-javascript text/xml application/xml application/xml+rss text/javascript;

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;

  include "{{NGINX_CONFDIR}}/vhosts/*.conf";

  # HTTP Server
  server {
    # port to listen on. Can also be set to an IP:PORT
    listen {{NGINX_HTTP_PORT_NUMBER}};

    location /status {
      stub_status on;
      access_log   off;
      allow 127.0.0.1;
      deny all;
    }
  }
}

