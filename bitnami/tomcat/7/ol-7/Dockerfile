FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl glibc gzip hostname keyutils-libs krb5-libs libaio-devel libcom_err libselinux nss-softokn-freebl openssl-libs pcre procps-ng sudo tar which zlib
RUN . ./libcomponent.sh && component_unpack "java" "11.0.5-0" --checksum e45456416649c404add4f02355d6efe6c82f960153a9807e4ba9fea16d28a237
RUN . ./libcomponent.sh && component_unpack "tomcat" "7.0.99-1" --checksum f9623928db9d03ca19998426ded936fda9dd29d8a3053f4248f8cb4ea1fe0f50
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="tomcat" \
    BITNAMI_IMAGE_VERSION="7.0.99-ol-7-r34" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:$PATH"

EXPOSE 8080

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
