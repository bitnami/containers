# Default SSL Virtual Host configuration.

<IfModule !ssl_module>
  LoadModule ssl_module modules/mod_ssl.so
</IfModule>

Listen 443
SSLProtocol all -SSLv2 -SSLv3
SSLHonorCipherOrder on
SSLCipherSuite "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS !EDH !RC4"
SSLPassPhraseDialog  builtin
SSLSessionCache "shmcb:{{APACHE_LOGS_DIR}}/ssl_scache(512000)"
SSLSessionCacheTimeout  300

<VirtualHost _default_:443>
  DocumentRoot "{{APACHE_BASE_DIR}}/htdocs"
  SSLEngine on
  SSLCertificateFile "{{APACHE_CONF_DIR}}/bitnami/certs/server.crt"
  SSLCertificateKeyFile "{{APACHE_CONF_DIR}}/bitnami/certs/server.key"

  <Directory "{{APACHE_BASE_DIR}}/htdocs">
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
  </Directory>

  # Error Documents
  ErrorDocument 503 /503.html

</VirtualHost>
