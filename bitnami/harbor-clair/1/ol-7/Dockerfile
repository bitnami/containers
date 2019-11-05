FROM bitnami/oraclelinux-extras-base:7-r470
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libcurl libidn libselinux libssh2 nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre zlib
RUN . ./libcomponent.sh && component_unpack "git" "2.24.0-0" --checksum a05099de6d8c26088d81b69c3519e45e481d4605beffaa509eb5b6e6dfed0d90
RUN . ./libcomponent.sh && component_unpack "harbor-clair" "1.9.2-0" --checksum 0495d3ea41ca971536d17d40bed4ca255ae39be46bb004c9fdde7080f7d95a55

COPY rootfs /
ENV BITNAMI_APP_NAME="harbor-clair" \
    BITNAMI_IMAGE_VERSION="1.9.2-ol-7-r0" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/git/bin:/opt/bitnami/harbor-clair/bin:$PATH"

EXPOSE 6060 6061

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
