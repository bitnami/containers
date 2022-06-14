# BEGIN nip.io redirection
if ($host ~ "^(?<ip>[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})(?<port>:[0-9]{1,5})?$") {
    return 302 $scheme://$ip.nip.io$port$uri;
}
# END nip.io redirection
