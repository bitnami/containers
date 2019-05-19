FROM bitnami/oraclelinux-extras-base:7-r288
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc keyutils-libs krb5-libs libcom_err libedit libselinux libxml2 libxslt ncurses-libs nss-softokn-freebl openssl-libs pcre xz-libs zlib
RUN . ./libcomponent.sh && component_unpack "postgresql" "10.8.0-0" --checksum 7f4a75b494bc263a5d71cb30d01ea99cbb964c05f5cde1fe863ed00dcc267f13

COPY rootfs /
RUN rpm -Uvh --nodeps $(repoquery --location nss_wrapper)
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="postgresql" \
    BITNAMI_IMAGE_VERSION="10.8.0-ol-7-r6" \
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
