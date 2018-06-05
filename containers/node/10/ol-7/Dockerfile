FROM bitnami/oraclelinux-extras:7-r5
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages build-essential bzip2-libs ca-certificates curl git glibc keyutils-libs krb5-libs libcom_err libgcc libselinux libstdc++ ncurses-libs nss-softokn-freebl openssl-libs pcre pkg-config readline sqlite unzip wget zlib
RUN bitnami-pkg install node-10.3.0-0 --checksum 6d351c8786a1e3c5342a47617769056e974e1167049bdbef6ffaa8e1c58ad301

COPY rootfs /
ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="10.3.0-ol-7-r0" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"

EXPOSE 3000

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["node"]
