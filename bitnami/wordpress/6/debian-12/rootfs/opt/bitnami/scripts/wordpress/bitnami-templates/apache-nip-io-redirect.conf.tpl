# BEGIN nip.io redirection
RewriteEngine On
RewriteCond %{HTTP_HOST} ^([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})(:[0-9]{1,5})?$
RewriteRule ^/?(.*) %{REQUEST_SCHEME}://%1.nip.io%2/$1 [L,R=302,NE]
# END nip.io redirection
