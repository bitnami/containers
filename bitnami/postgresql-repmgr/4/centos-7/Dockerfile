FROM bitnami/centos-extras-base:7-r156
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="centos-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc keyutils-libs krb5-libs libcom_err libedit libgcc libicu libselinux libstdc++ libuuid libxml2 libxslt ncurses-libs nss-softokn-freebl openssl-libs pcre xz-libs zlib
RUN . ./libcomponent.sh && component_unpack "postgresql-repmgr" "4.0.3-1" --checksum 7f579c969d7f2c0caed80c5595815b6ca225133b2a2e942e76114e6c640db03a

COPY rootfs /
RUN yum --enablerepo base,updates,extras -y install epel-release && yum --enablerepo base,updates,extras -y update && yum --enablerepo base,updates -y install nss_wrapper
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="postgresql-repmgr" \
    BITNAMI_IMAGE_VERSION="4.0.3-centos-7-r32" \
    NAMI_PREFIX="/.nami" \
    NSS_WRAPPER_LIB="/usr/lib64/libnss_wrapper.so" \
    PATH="/opt/bitnami/postgresql-repmgr/bin:/opt/bitnami/repmgr/bin:/opt/bitnami/postgresql/bin:$PATH"

EXPOSE 5432

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
