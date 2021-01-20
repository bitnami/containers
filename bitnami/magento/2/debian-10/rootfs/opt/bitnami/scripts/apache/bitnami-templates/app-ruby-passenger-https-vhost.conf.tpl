{{before_vhost_configuration}}
PassengerPreStart https://localhost:{{APACHE_DEFAULT_HTTPS_PORT_NUMBER}}/
<VirtualHost {{https_listen_addresses}}>
  ServerAlias *
  SSLEngine on
  SSLCertificateFile "{{APACHE_CONF_DIR}}/bitnami/certs/server.crt"
  SSLCertificateKeyFile "{{APACHE_CONF_DIR}}/bitnami/certs/server.key"
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
