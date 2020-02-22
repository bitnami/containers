FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl glibc gzip hostname keyutils-libs krb5-libs libaio-devel libcom_err libselinux nss-softokn-freebl openssl-libs pcre procps-ng sudo tar which zlib
RUN . ./libcomponent.sh && component_unpack "java" "11.0.6-0" --checksum 44f5ec63dbe8d2ea9aaea237cec2d8821ac3ee6fa2812c295c0fa04068d0e08e
RUN . ./libcomponent.sh && component_unpack "tomcat" "7.0.100-1" --checksum 7959d1e0895e25f7640b0d5f8c02be5cb0aa2612c3bdd9c7019460bb7a040ddf
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="tomcat" \
    BITNAMI_IMAGE_VERSION="7.0.100-ol-7-r8" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:$PATH"

EXPOSE 8080

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
