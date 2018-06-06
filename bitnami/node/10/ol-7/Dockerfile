FROM bitnami/oraclelinux-extras:7-r5
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages build-essential bzip2-libs ca-certificates curl git glibc keyutils-libs krb5-libs libcom_err libgcc libselinux libstdc++ ncurses-libs nss-softokn-freebl openssl-libs pcre pkg-config readline sqlite unzip wget zlib
RUN bitnami-pkg install node-10.4.0-0 --checksum 4d6a5b07fff734961e06a11dd04c0940a426d966595f84e93f2ee466c189ed60

COPY rootfs /
ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="10.4.0-ol-7-r0" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"

EXPOSE 3000

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["node"]
