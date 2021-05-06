{{before_vhost_configuration}}
PassengerPreStart http://localhost:{{APACHE_DEFAULT_HTTP_PORT_NUMBER}}/
<VirtualHost {{http_listen_addresses}}>
  ServerAlias *
  DocumentRoot {{document_root}}
  <Directory "{{document_root}}">
    Options -Indexes +FollowSymLinks -MultiViews
    AllowOverride {{allow_override}}
    {{acl_configuration}}
    PassengerEnabled on
    {{extra_directory_configuration}}
  </Directory>
  {{additional_configuration}}
</VirtualHost>
