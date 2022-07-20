{{http_listen_configuration}}
{{before_vhost_configuration}}
PassengerPreStart http://localhost:{{http_port}}/
<VirtualHost {{http_listen_addresses}}>
  {{server_name_configuration}}
  DocumentRoot {{document_root}}
  <Directory "{{document_root}}">
    Options -Indexes +FollowSymLinks -MultiViews
    AllowOverride {{allow_override}}
    {{acl_configuration}}
    PassengerEnabled on
    {{extra_directory_configuration}}
  </Directory>
  {{additional_http_configuration}}
  {{additional_configuration}}
</VirtualHost>
