FROM bitnami/minideb-extras:jessie-r19
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libpcre3 libssl1.0.0 zlib1g
RUN bitnami-pkg unpack nginx-1.12.1-1 --checksum 64fa2a275865a91143f6f676dcec112ec1b8dfd4e6f6fbae683597a169a1ad1e
RUN ln -sf /opt/bitnami/nginx/html /app

COPY rootfs /

ENV BITNAMI_APP_NAME="nginx" \
    BITNAMI_IMAGE_VERSION="1.12.1-r1" \
    NGINX_DAEMON_GROUP="nginx" \
    NGINX_DAEMON_USER="nginx" \
    NGINX_HTTPS_PORT_NUMBER="443" \
    NGINX_HTTP_PORT_NUMBER="80" \
    PATH="/opt/bitnami/nginx/sbin:$PATH"

EXPOSE 80 443

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
