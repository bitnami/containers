FROM bitnami/centos-extras-base:7-r177
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="centos-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc keyutils-libs krb5-libs libcom_err libedit libselinux libuuid libxml2 libxslt ncurses-libs nss-softokn-freebl openssl-libs pcre xz-libs zlib
RUN . ./libcomponent.sh && component_unpack "postgresql" "9.6.15-3" --checksum facb9e80012335911c1413c5c50bf9b1a83bbdb046520cb0218c0899dadf6862

COPY rootfs /
RUN yum --enablerepo base,updates,extras -y install epel-release && yum --enablerepo base,updates,extras -y update && yum --enablerepo base,updates -y install nss_wrapper
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="postgresql" \
    BITNAMI_IMAGE_VERSION="9.6.15-centos-7-r80" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    NAMI_PREFIX="/.nami" \
    NSS_WRAPPER_LIB="/usr/lib64/libnss_wrapper.so" \
    PATH="/opt/bitnami/postgresql/bin:$PATH"

VOLUME [ "/bitnami/postgresql", "/docker-entrypoint-initdb.d", "/docker-entrypoint-preinitdb.d" ]

EXPOSE 5432

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
