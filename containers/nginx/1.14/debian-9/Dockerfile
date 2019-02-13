FROM bitnami/minideb-extras-base:stretch-r160
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/bitnami/nginx/conf" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 libpcre3 libssl1.1 zlib1g
RUN . ./libcomponent.sh && component_unpack "nginx" "1.14.2-21" --checksum 73c924db078bebc7173aa5a596036285d1da41cbe985d1e4cc024f681e6dca52
RUN ln -sf /opt/bitnami/nginx/html /app
RUN ln -sf /dev/stdout /opt/bitnami/nginx/logs/access.log
RUN ln -sf /dev/stderr /opt/bitnami/nginx/logs/error.log

COPY rootfs /
RUN /prepare.sh
ENV BITNAMI_APP_NAME="nginx" \
    BITNAMI_IMAGE_VERSION="1.14.2-debian-9-r62" \
    NAMI_PREFIX="/.nami" \
    NGINX_DAEMON_GROUP="" \
    NGINX_DAEMON_USER="" \
    NGINX_HTTPS_PORT_NUMBER="443" \
    NGINX_HTTP_PORT_NUMBER="8080" \
    PATH="/opt/bitnami/nginx/sbin:$PATH"

EXPOSE 8080

WORKDIR /app
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
