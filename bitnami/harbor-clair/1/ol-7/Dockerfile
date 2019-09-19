FROM bitnami/oraclelinux-extras-base:7-r422
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libcurl libidn libselinux libssh2 nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre zlib
RUN . ./libcomponent.sh && component_unpack "git" "2.23.0-0" --checksum 30618c63e72727b90b3cc3e7f8747e599ec11352b29812285a27029807d8766d
RUN . ./libcomponent.sh && component_unpack "harbor-clair" "1.8.3-0" --checksum ba572976afea01c0c9f53471b95837e9c2d74606deebc3a16926b51cf23fcbb0

COPY rootfs /
ENV BITNAMI_APP_NAME="harbor-clair" \
    BITNAMI_IMAGE_VERSION="1.8.3-ol-7-r1" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/git/bin:/opt/bitnami/harbor-clair/bin:$PATH"

EXPOSE 6060 6061

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
