FROM bitnami/oraclelinux-extras-base:7-r421
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libcurl libgcc libidn libpcap libselinux libssh2 nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre zlib
RUN . ./libcomponent.sh && component_unpack "mongodb" "4.0.12-0" --checksum d756b834857a1827df6c42a1fb3c579353507f64eb5f9201714d9c537d4a82bb

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="mongodb" \
    BITNAMI_IMAGE_VERSION="4.0.12-ol-7-r43" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/mongodb/bin:$PATH"

EXPOSE 27017

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
