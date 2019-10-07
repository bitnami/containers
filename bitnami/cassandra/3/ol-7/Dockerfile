FROM bitnami/oraclelinux-extras-base:7-r440
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages bzip2-libs glibc keyutils-libs krb5-libs libcom_err libgcc libselinux ncurses-libs nss-softokn-freebl openssl-libs pcre readline sqlite zlib
RUN . ./libcomponent.sh && component_unpack "python" "2.7.16-1" --checksum b2f323fe1c8d252c73cd4c9c58456bdb73b32bfa40a03c4ee43b7f37a7ab9d40
RUN . ./libcomponent.sh && component_unpack "java" "1.8.222-1" --checksum 664cacaa11342e877410b197d21343543c2987cd66f15d2adc32cc61eee48eaa
RUN . ./libcomponent.sh && component_unpack "cassandra" "3.11.4-4" --checksum dc69551c0083de26e10182eb38e54ca4761b90fac588b2b57ada041733f9bd55

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="cassandra" \
    BITNAMI_IMAGE_VERSION="3.11.4-ol-7-r228" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/java/bin:/opt/bitnami/cassandra/bin:$PATH"

EXPOSE 9042 7000

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
