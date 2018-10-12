FROM bitnami/oraclelinux-extras-base:7-r81
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/bitnami/nginx/conf" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc keyutils-libs krb5-libs libcom_err libselinux nss-softokn-freebl openssl-libs pcre zlib
RUN . ./libcomponent.sh && component_unpack "nginx" "1.14.0-4" --checksum 03cc1bffbb50ede2e777edcb4be83d9c16cde934e86fcc8b417b115ea4bcd615
RUN . ./libcomponent.sh && component_unpack "kubeapps-dashboard" "1.0.0-beta.2-0" --checksum 0ba9b59c4cd9af29c1669025f6c769590b5a725957a1093cdedc51214f0216ca
RUN ln -sf /opt/bitnami/nginx/html /app
RUN ln -sf /dev/stdout /opt/bitnami/nginx/logs/access.log
RUN ln -sf /dev/stdout /opt/bitnami/nginx/logs/error.log

COPY rootfs /
RUN /prepare.sh
RUN rm -rf /opt/bitnami/nginx/html && mv /opt/bitnami/kubeapps-dashboard/build /opt/bitnami/nginx/html
ENV BITNAMI_APP_NAME="kubeapps-dashboard" \
    BITNAMI_IMAGE_VERSION="1.0.0-beta.2-ol-7-r1" \
    NGINX_DAEMON_GROUP="" \
    NGINX_DAEMON_USER="" \
    NGINX_HTTP_PORT_NUMBER="8080" \
    PATH="/opt/bitnami/nginx/sbin:/opt/bitnami/kubeapps-dashboard/bin:$PATH"

EXPOSE 8080

WORKDIR /app
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
