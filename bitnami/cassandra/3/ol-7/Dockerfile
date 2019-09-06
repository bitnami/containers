FROM bitnami/oraclelinux-extras-base:7-r409
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages bzip2-libs glibc keyutils-libs krb5-libs libcom_err libgcc libselinux ncurses-libs nss-softokn-freebl openssl-libs pcre readline sqlite zlib
RUN . ./libcomponent.sh && component_unpack "python" "2.7.16-0" --checksum f1818dfd2f72ba498d54702d4e6aa44fcdecc1f0b1fc7d99703e74b4626f6395
RUN . ./libcomponent.sh && component_unpack "java" "1.8.222-0" --checksum a90f4ce71ff9b392efdf61e6941117afa31d2d6528bd1a3cad1c6459bcac2b0b
RUN . ./libcomponent.sh && component_unpack "cassandra" "3.11.4-3" --checksum 64788e4a1c77818adc285cae90b159d45d40b8488440d3c1d0dd253f3c854b72

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="cassandra" \
    BITNAMI_IMAGE_VERSION="3.11.4-ol-7-r202" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/java/bin:/opt/bitnami/cassandra/bin:$PATH"

EXPOSE 9042 7000

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
