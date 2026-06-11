# Default SSL Virtual Host configuration.

<IfModule !ssl_module>
  LoadModule ssl_module modules/mod_ssl.so
</IfModule>

Listen 443
SSLProtocol all -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
# Ciphers for TLS 1.2, see https://wiki.mozilla.org/Security/Server_Side_TLS
SSLCipherSuite ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
SSLHonorCipherOrder  off
SSLSessionTickets  off
SSLPassPhraseDialog  builtin
SSLSessionCache "shmcb:{{APACHE_LOGS_DIR}}/ssl_scache(512000)"
SSLSessionCacheTimeout  300

<VirtualHost _default_:443>
  DocumentRoot "{{APACHE_BASE_DIR}}/htdocs"
  SSLEngine on
  SSLCertificateFile "{{APACHE_CONF_DIR}}/bitnami/certs/tls.crt"
  SSLCertificateKeyFile "{{APACHE_CONF_DIR}}/bitnami/certs/tls.key"

  <Directory "{{APACHE_BASE_DIR}}/htdocs">
    Options FollowSymLinks
    AllowOverride All
    Require all granted
  </Directory>

  # Error Documents
  ErrorDocument 503 /503.html
</VirtualHost>
