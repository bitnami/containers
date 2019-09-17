FROM bitnami/oraclelinux-extras-base:7-r420
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc keyutils-libs krb5-libs libcom_err libgcc libpcap libselinux openssl-libs pcre zlib
RUN . ./libcomponent.sh && component_unpack "mongodb" "3.6.14-0" --checksum 04fb15d9e84cabb018c5f1df2020ce718cdc6ed0edb71e6c6bdc004600754f2e

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="mongodb" \
    BITNAMI_IMAGE_VERSION="3.6.14-ol-7-r29" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/mongodb/bin:$PATH"

EXPOSE 27017

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
