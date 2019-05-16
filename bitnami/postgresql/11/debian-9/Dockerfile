FROM bitnami/minideb-extras-base:stretch-r240
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libbsd0 libc6 libedit2 libgcc1 libicu57 liblzma5 libncurses5 libnss-wrapper libssl1.1 libstdc++6 libtinfo5 libxml2 libxslt1.1 locales zlib1g
RUN . ./libcomponent.sh && component_unpack "postgresql" "11.3.0-0" --checksum 55a4ee5d16c995f42a861afe407ed1fbef1d6b73203c26b3af7bf2a219cb2f68
RUN echo 'en_GB.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="postgresql" \
    BITNAMI_IMAGE_VERSION="11.3.0-debian-9-r3" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    NAMI_PREFIX="/.nami" \
    NSS_WRAPPER_LIB="/usr/lib/libnss_wrapper.so" \
    PATH="/opt/bitnami/postgresql/bin:$PATH"

VOLUME [ "/bitnami/postgresql", "/docker-entrypoint-initdb.d" ]

EXPOSE 5432

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
