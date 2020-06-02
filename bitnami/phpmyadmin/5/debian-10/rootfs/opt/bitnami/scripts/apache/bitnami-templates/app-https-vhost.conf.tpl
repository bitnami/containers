<VirtualHost {{https_listen_addresses}}>
  ServerAlias *
  DocumentRoot {{document_root}}
  SSLEngine on
  SSLCertificateFile "{{APACHE_CONF_DIR}}/bitnami/certs/server.crt"
  SSLCertificateKeyFile "{{APACHE_CONF_DIR}}/bitnami/certs/server.key"
  <Directory "{{document_root}}">
    Options -Indexes +FollowSymLinks -MultiViews
    AllowOverride {{allow_override}}
    {{acl_configuration}}
    {{extra_directory_configuration}}
  </Directory>
  {{additional_configuration}}
  {{htaccess_include}}
</VirtualHost>
