FROM bitnami/minideb-extras-base:stretch-r377
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libbsd0 libc6 libedit2 libgcc1 libicu57 liblzma5 libncurses5 libnss-wrapper libssl1.1 libstdc++6 libtinfo5 libuuid1 libxml2 libxslt1.1 locales zlib1g
RUN . ./libcomponent.sh && component_unpack "postgresql-repmgr" "10.10.0-0" --checksum bd73d00b732b1f18d083b9d65316b625302d314d11c49495bf300c1073f88a70
RUN echo 'en_GB.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="postgresql-repmgr" \
    BITNAMI_IMAGE_VERSION="10.10.0-debian-9-r16" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    NAMI_PREFIX="/.nami" \
    NSS_WRAPPER_LIB="/usr/lib/libnss_wrapper.so" \
    PATH="/opt/bitnami/postgresql-repmgr/bin:/opt/bitnami/repmgr/bin:/opt/bitnami/postgresql/bin:$PATH"

EXPOSE 5432

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
