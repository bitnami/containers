{{https_listen_configuration}}
{{before_vhost_configuration}}
PassengerPreStart https://localhost:{{https_port}}/
<VirtualHost {{https_listen_addresses}}>
  {{server_name_configuration}}
  SSLEngine on
  SSLCertificateFile "{{APACHE_CONF_DIR}}/bitnami/certs/tls.crt"
  SSLCertificateKeyFile "{{APACHE_CONF_DIR}}/bitnami/certs/tls.key"
  DocumentRoot {{document_root}}
  <Directory "{{document_root}}">
    Options -Indexes +FollowSymLinks -MultiViews
    AllowOverride {{allow_override}}
    {{acl_configuration}}
    PassengerEnabled on
    {{extra_directory_configuration}}
  </Directory>
  {{additional_https_configuration}}
  {{additional_configuration}}
</VirtualHost>
