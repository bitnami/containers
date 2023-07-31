location ^~ {{location}} {
    alias "{{document_root}}";

    {{acl_configuration}}

    include "/opt/bitnami/nginx/conf/bitnami/protect-hidden-files.conf";
    include "/opt/bitnami/nginx/conf/bitnami/php-fpm.conf";
}

{{additional_configuration}}
