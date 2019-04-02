FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates curl gcc gcc-c++ git glibc keyutils-libs krb5-libs libcom_err libgcc libselinux libstdc++ libtool make ncurses-libs nss-softokn-freebl openssl-libs patch pcre pkgconfig readline sqlite unzip wget zlib
RUN bitnami-pkg install node-8.15.1-1 --checksum de29e7a27e11f42aa5799f733916b616971d1be463ceafd5bf07e9c411e861a5

COPY rootfs /
ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="8.15.1-rhel-7-r33" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"

EXPOSE 3000

WORKDIR /app
USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "node" ]
