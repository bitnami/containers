{{before_vhost_configuration}}
<VirtualHost {{http_listen_addresses}}>
  ServerAlias *
  {{additional_configuration}}
</VirtualHost>
