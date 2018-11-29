FROM bitnami/oraclelinux-extras-base:7-r128
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/bitnami/nginx/conf" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc keyutils-libs krb5-libs libcom_err libselinux nss-softokn-freebl openssl-libs pcre zlib
RUN . ./libcomponent.sh && component_unpack "nginx" "1.14.1-1" --checksum 19dcb341287be883791cfec187fce87cf6a0b90c54d4e0bd8bdeec06f7629265
RUN ln -sf /opt/bitnami/nginx/html /app
RUN ln -sf /dev/stdout /opt/bitnami/nginx/logs/access.log
RUN ln -sf /dev/stdout /opt/bitnami/nginx/logs/error.log

COPY rootfs /
RUN /prepare.sh
ENV BITNAMI_APP_NAME="nginx" \
    BITNAMI_IMAGE_VERSION="1.14.1-ol-7-r20" \
    NGINX_DAEMON_GROUP="" \
    NGINX_DAEMON_USER="" \
    NGINX_HTTP_PORT_NUMBER="8080" \
    PATH="/opt/bitnami/nginx/sbin:$PATH"

EXPOSE 8080

WORKDIR /app
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
