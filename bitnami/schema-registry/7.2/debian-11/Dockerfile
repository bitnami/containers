FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"
LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="7.2.1-debian-11-r3" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/schema-registry" \
      org.opencontainers.image.title="schema-registry" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="7.2.1"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 netcat-traditional procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.15-1-3" --checksum 7214b8ab81c9d919f87f027590ca80c198f65fe50c5e2886d8e5e20691aee8d7
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "schema-registry" "7.2.1-1" --checksum f66c535f2b1a1c85977ff82012a508a65b5b3c856b934d6eb608f43c49a52070
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-154" --checksum e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/schema-registry/postunpack.sh
ENV APP_VERSION="7.2.1" \
    BITNAMI_APP_NAME="schema-registry" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/schema-registry/bin:/opt/bitnami/common/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/schema-registry/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/schema-registry/run.sh" ]
