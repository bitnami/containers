{{before_vhost_configuration}}
<VirtualHost {{http_listen_addresses}}>
  ServerAlias *
  DocumentRoot {{document_root}}
  <Directory "{{document_root}}">
    Options -Indexes +FollowSymLinks -MultiViews
    AllowOverride {{allow_override}}
    {{acl_configuration}}
    {{extra_directory_configuration}}
  </Directory>
  {{additional_configuration}}
  {{htaccess_include}}
</VirtualHost>
