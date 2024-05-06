# BEGIN WordPress Multisite
# Using subdomain network type: https://wordpress.org/support/article/nginx/#wordpress-multisite-subdomains-rules

location / {
    try_files $uri $uri/ /index.php?$args ;
}

# WPMU Files
location ~ ^/files/(.*)$ {
    try_files /wp-content/blogs.dir/$blogid/$uri /wp-includes/ms-files.php?file=$1 ;
    access_log off;
    log_not_found off;
    expires max;
}

# WPMU x-sendfile to avoid php readfile()
location ^~ /blogs.dir {
    internal;
    alias {{WORDPRESS_BASE_DIR}}/wp-content/blogs.dir;
    access_log off;
    log_not_found off;
    expires max;
}

# END WordPress Multisite
