{{prefix_conf}}
<Directory "{{document_root}}">
  Options -Indexes +FollowSymLinks -MultiViews
  AllowOverride {{allow_override}}
  {{acl_configuration}}
  PassengerEnabled on
  {{extra_directory_configuration}}
</Directory>
{{additional_configuration}}
