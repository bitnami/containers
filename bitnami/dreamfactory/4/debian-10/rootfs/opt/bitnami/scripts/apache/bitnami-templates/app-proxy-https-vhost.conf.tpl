{{before_vhost_configuration}}
<VirtualHost {{https_listen_addresses}}>
  ServerAlias *
  SSLEngine on
  SSLCertificateFile "{{APACHE_CONF_DIR}}/bitnami/certs/server.crt"
  SSLCertificateKeyFile "{{APACHE_CONF_DIR}}/bitnami/certs/server.key"
  {{proxy_configuration}}
  {{proxy_https_configuration}}
  ProxyPass / {{proxy_address}}
  ProxyPassReverse / {{proxy_address}}
  {{additional_configuration}}
</VirtualHost>
