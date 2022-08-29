FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"
LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="26.1.1-debian-11-r33" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/wildfly" \
      org.opencontainers.image.title="wildfly" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="26.1.1"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libaio1 libc6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.15-1-3" --checksum 7214b8ab81c9d919f87f027590ca80c198f65fe50c5e2886d8e5e20691aee8d7
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wildfly" "26.1.1-158" --checksum 17001caa64a6ac25076d8b1725afc433da62de54723f8b62544cd92ead756302
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-154" --checksum e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/wildfly/postunpack.sh
ENV APP_VERSION="26.1.1" \
    BITNAMI_APP_NAME="wildfly" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/wildfly/bin:/opt/bitnami/common/bin:$PATH" \
    WILDFLY_HOME="/home/wildfly"

EXPOSE 8080 9990

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/wildfly/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/wildfly/run.sh" ]
