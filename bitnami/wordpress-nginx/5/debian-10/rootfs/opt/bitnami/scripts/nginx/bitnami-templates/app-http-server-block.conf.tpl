{{external_configuration}}

server {
    # Port to listen on, can also be set in IP:PORT format
    {{http_listen_configuration}}

    root {{document_root}};

    # Catch-all server block
    # See: https://nginx.org/en/docs/http/server_names.html#miscellaneous_names
    server_name _;

    {{acl_configuration}}

    {{additional_configuration}}

    include  "/opt/bitnami/nginx/conf/bitnami/*.conf";
}
