# BEGIN Disable WordPress XML-RPC endpoint
# Disable the outdated WordPress XML-RPC endpoint to prevent security vulnerabilities.
# https://github.com/bitnami/containers/pull/51077
location = /xmlrpc.php {
    deny all;
}
# END Disable WordPress XML-RPC endpoint