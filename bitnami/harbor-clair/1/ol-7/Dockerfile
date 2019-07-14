FROM bitnami/oraclelinux-extras-base:7-r347
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libcurl libidn libselinux libssh2 nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre zlib
RUN . ./libcomponent.sh && component_unpack "git" "2.22.0-0" --checksum 5dc73d3ed8b4f84c89e75fd7c08ec147a528eaf1017946d68c3732748885b3e2
RUN . ./libcomponent.sh && component_unpack "harbor-clair" "1.8.1-0" --checksum 52432371061d009697bf0a1994d58ce446415489a608e4a879d34316f39956b0

COPY rootfs /
ENV BITNAMI_APP_NAME="harbor-clair" \
    BITNAMI_IMAGE_VERSION="1.8.1-ol-7-r12" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/git/bin:/opt/bitnami/harbor-clair/bin:$PATH"

EXPOSE 6060 6061

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
