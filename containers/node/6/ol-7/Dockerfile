FROM bitnami/oraclelinux-extras:7-r26
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages build-essential bzip2-libs ca-certificates curl git glibc keyutils-libs krb5-libs libcom_err libgcc libselinux libstdc++ ncurses-libs nss-softokn-freebl openssl-libs pcre pkg-config readline sqlite unzip wget zlib
RUN bitnami-pkg install node-6.14.3-0 --checksum 25b262d60a690ba17ab9a35503af41cfdfd052c680364c20bb6c5b0f6f87b64b

COPY rootfs /
ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="6.14.3-ol-7-r14" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"

EXPOSE 3000

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["node"]
