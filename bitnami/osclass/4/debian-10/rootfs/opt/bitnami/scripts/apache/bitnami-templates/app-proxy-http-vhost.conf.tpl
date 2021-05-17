<VirtualHost {{http_listen_addresses}}>
  ServerAlias *
  ProxyPass / {{proxy_address}}
  ProxyPassReverse / {{proxy_address}}
  {{additional_configuration}}
</VirtualHost>
