FROM bitnami/minideb-extras:jessie-r19
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libpcre3 libssl1.0.0 zlib1g
RUN bitnami-pkg unpack nginx-1.12.1-0 --checksum fbbe00d621cd32ce25edb312dca41b22252d63c81c6aa525c55739e3c6529250
RUN ln -sf /opt/bitnami/nginx/html /app

COPY rootfs /

ENV BITNAMI_APP_NAME="nginx" \
    BITNAMI_IMAGE_VERSION="1.12.1-r0" \
    NGINX_DAEMON_GROUP="nginx" \
    NGINX_DAEMON_USER="nginx" \
    NGINX_HTTPS_PORT_NUMBER="443" \
    NGINX_HTTP_PORT_NUMBER="80" \
    PATH="/opt/bitnami/nginx/sbin:$PATH"

EXPOSE 80 443

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
