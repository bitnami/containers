FROM bitnami/centos-extras-base:7-r55
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="centos-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages GeoIP glibc keyutils-libs krb5-libs libcom_err libselinux nss-softokn-freebl openssl-libs pcre zlib
RUN . ./libcomponent.sh && component_unpack "nginx" "1.16.0-7" --checksum 3a798f25aa6b251c6a2a62abbc3f83347d081a9eea5cb4b57444248c63b96753
RUN ln -sf /dev/stdout /opt/bitnami/nginx/logs/access.log
RUN ln -sf /dev/stderr /opt/bitnami/nginx/logs/error.log
RUN chmod -R g+rwX /opt/bitnami/nginx/conf

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="nginx" \
    BITNAMI_IMAGE_VERSION="1.16.0-centos-7-r39" \
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
