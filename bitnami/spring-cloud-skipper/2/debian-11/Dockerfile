FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"
LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.8.5-debian-11-r4" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/spring-cloud-skipper" \
      org.opencontainers.image.title="spring-cloud-skipper" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.8.5"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libgcc-s1 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.345-1" --checksum 4d90bf2066c8d6605ac771e9b97c1188f4491d458fcb56956eeead6a18f70ac4
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.27.2-1" --checksum 44d0058c0fffa1ccc89c081ed3e5c897489fa02580a839cfe1d37b2ca771f237
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "spring-cloud-skipper" "2.8.5-1" --checksum d9d1f8edec5cb4c19c9253b27a7522728f52b40c7a036bd0b472896c0f3e5fe0
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-153" --checksum d3ae0109be24e8bc56f97359b8290b91243454de946dd60bd8520a0896a88449
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/spring-cloud-skipper/postunpack.sh
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV APP_VERSION="2.8.5" \
    BITNAMI_APP_NAME="spring-cloud-skipper" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/spring-cloud-skipper/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/spring-cloud-skipper/run.sh" ]
