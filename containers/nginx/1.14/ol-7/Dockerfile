FROM bitnami/oraclelinux-extras-base:7-r267
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc keyutils-libs krb5-libs libcom_err libselinux nss-softokn-freebl openssl-libs pcre zlib
RUN . ./libcomponent.sh && component_unpack "nginx" "1.14.2-21" --checksum d4d907cc0c038a32cb7fe0d681552f469a5d6c2af51d12fe83c710f250c2e463

COPY rootfs /
RUN /prepare.sh

ENV BITNAMI_APP_NAME="nginx" \
    BITNAMI_IMAGE_VERSION="1.14.2-ol-7-r131" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/nginx/sbin:$PATH"

EXPOSE 8080 8443
VOLUME [ "/app" "/certs" ]
WORKDIR /app
USER 1001

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
