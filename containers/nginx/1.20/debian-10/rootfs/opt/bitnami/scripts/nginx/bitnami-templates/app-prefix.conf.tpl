location ^~ {{location}} {
    alias "{{document_root}}";

    {{acl_configuration}}

    include "/opt/bitnami/nginx/conf/bitnami/protect-hidden-files.conf";
}

{{additional_configuration}}
