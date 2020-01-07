FROM bitnami/centos-extras-base:7-r260
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="centos-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc keyutils-libs krb5-libs libcom_err libgcc libpcap libselinux openssl-libs pcre zlib
RUN . ./libcomponent.sh && component_unpack "mongodb" "3.6.16-0" --checksum 4c99670f1e4f44786c2c9051bf0b5a278dace7f5326503d4634ad6961ced98e0

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="mongodb-sharded" \
    BITNAMI_IMAGE_VERSION="3.6.16-centos-7-r37" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/mongodb/bin:$PATH"

EXPOSE 27017

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
