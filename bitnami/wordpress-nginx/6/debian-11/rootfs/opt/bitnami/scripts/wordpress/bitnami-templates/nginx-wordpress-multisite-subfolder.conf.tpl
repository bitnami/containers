# BEGIN WordPress Multisite
# Using subfolder network type: https://wordpress.org/support/article/nginx/#wordpress-multisite-subdirectory-rules

location ~ ^(/[^/]+/)?files/(.+) {
    try_files /wp-content/blogs.dir/$blogid/files/$2 /wp-includes/ms-files.php?file=$2 ;
    access_log off;     log_not_found off; expires max;
}

#avoid php readfile()
location ^~ /blogs.dir {
    internal;
    alias {{WORDPRESS_BASE_DIR}}/wp-content/blogs.dir ;
    access_log off;     log_not_found off; expires max;
}

if (!-e $request_filename) {
    rewrite /wp-admin$ $scheme://$host$request_uri/ permanent;
    rewrite ^(/[^/]+)?(/wp-.*) $2 last;
    rewrite ^(/[^/]+)?(/.*\.php) $2 last;
}

location / {
    try_files $uri $uri/ /index.php?$args ;
}

# END WordPress Multisite
