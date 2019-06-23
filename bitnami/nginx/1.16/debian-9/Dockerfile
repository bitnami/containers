FROM bitnami/minideb-extras-base:stretch-r281
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 libgeoip1 libpcre3 libssl1.1 zlib1g
RUN . ./libcomponent.sh && component_unpack "nginx" "1.16.0-9" --checksum fdcc0db2f9632ea80d5a7b104c0cc16d0b0fd6262ed4adac2da12add922783eb
RUN ln -sf /dev/stdout /opt/bitnami/nginx/logs/access.log
RUN ln -sf /dev/stderr /opt/bitnami/nginx/logs/error.log
RUN chmod -R g+rwX /opt/bitnami/nginx/conf

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="nginx" \
    BITNAMI_IMAGE_VERSION="1.16.0-debian-9-r59" \
    NAMI_PREFIX="/.nami" \
    NGINX_ENABLE_CUSTOM_PORTS="no" \
    NGINX_HTTPS_PORT_NUMBER="" \
    NGINX_HTTP_PORT_NUMBER="" \
    PATH="/opt/bitnami/nginx/sbin:$PATH"

VOLUME [ "/app", "/certs" ]

EXPOSE 8080 8443

WORKDIR /app
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
