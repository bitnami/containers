# BEGIN WordPress
# https://wordpress.org/support/article/nginx/#general-wordpress-rules
location = /favicon.ico {
    log_not_found off;
    access_log off;
}
location = /robots.txt {
    allow all;
    log_not_found off;
    access_log off;
}
location / {
    try_files $uri $uri/ /index.php?$args;
}
location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
    expires max;
    log_not_found off;
}
# END WordPress
