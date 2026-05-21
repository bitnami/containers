# BEGIN WordPress Multisite variable mapping for NGINX
# https://wordpress.org/support/article/nginx/#wordpress-multisite-subdirectory-rules
map $uri $blogname {
    ~^(?P<blogpath>/[^/]+/)files/(.*) $blogpath;
}
map $blogname $blogid {
    default -999;
    # Ref: https://wordpress.org/extend/plugins/nginx-helper/
    #include /opt/bitnami/wordpress/wp-content/plugins/nginx-helper/map.conf;
}
# END WordPress Multisite variable mapping for NGINX
