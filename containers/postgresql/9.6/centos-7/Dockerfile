FROM bitnami/centos-extras-base:7-r56
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="centos-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc keyutils-libs krb5-libs libcom_err libedit libselinux libxml2 libxslt ncurses-libs nss-softokn-freebl openssl-libs pcre xz-libs zlib
RUN . ./libcomponent.sh && component_unpack "postgresql" "9.6.14-0" --checksum 91f0b0496a257e4c1abee268aa4de82124d735a667ba62b67eed8b707030effc

COPY rootfs /
RUN yum -y install epel-release && yum -y update && yum -y install nss_wrapper
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="postgresql" \
    BITNAMI_IMAGE_VERSION="9.6.14-centos-7-r9" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    NAMI_PREFIX="/.nami" \
    NSS_WRAPPER_LIB="/usr/lib64/libnss_wrapper.so" \
    PATH="/opt/bitnami/postgresql/bin:$PATH"

VOLUME [ "/bitnami/postgresql", "/docker-entrypoint-initdb.d" ]

EXPOSE 5432

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
