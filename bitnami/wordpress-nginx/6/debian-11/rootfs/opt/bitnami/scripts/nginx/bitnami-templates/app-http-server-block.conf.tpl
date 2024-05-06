{{external_configuration}}

server {
    # Port to listen on, can also be set in IP:PORT format
    {{http_listen_configuration}}

    root {{document_root}};

    {{server_name_configuration}}

    {{acl_configuration}}

    {{additional_configuration}}

    include  "/opt/bitnami/nginx/conf/bitnami/*.conf";
}
