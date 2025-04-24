location ^~ {{location}} {
    alias "{{document_root}}";

    {{acl_configuration}}

    include "/opt/bitnami/nginx/conf/bitnami/00_protect-hidden-files.conf";
    include "/opt/bitnami/nginx/conf/bitnami/00_protect-uploads-dirs.conf";
    include "/opt/bitnami/nginx/conf/bitnami/php-fpm.conf";
}

{{additional_configuration}}
