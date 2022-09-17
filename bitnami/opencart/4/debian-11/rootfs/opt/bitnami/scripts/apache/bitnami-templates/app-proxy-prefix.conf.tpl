{{prefix_conf}}
<Directory "{{document_root}}">
  Options -Indexes +FollowSymLinks -MultiViews
  AllowOverride {{allow_override}}
  {{acl_configuration}}
  {{proxy_configuration}}
  ProxyPass / {{proxy_address}}
  ProxyPassReverse / {{proxy_address}}
  {{extra_directory_configuration}}
</Directory>
{{additional_configuration}}
