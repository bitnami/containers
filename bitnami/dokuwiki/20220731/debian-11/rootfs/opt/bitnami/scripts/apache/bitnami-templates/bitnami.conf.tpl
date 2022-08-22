# Default Virtual Host configuration.

# Let Apache know we're behind a SSL reverse proxy
SetEnvIf X-Forwarded-Proto https HTTPS=on

<VirtualHost _default_:80>
  DocumentRoot "{{APACHE_BASE_DIR}}/htdocs"
  <Directory "{{APACHE_BASE_DIR}}/htdocs">
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
  </Directory>

  # Error Documents
  ErrorDocument 503 /503.html
</VirtualHost>

Include "{{APACHE_CONF_DIR}}/bitnami/bitnami-ssl.conf"
