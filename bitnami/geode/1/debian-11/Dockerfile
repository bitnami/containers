FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"
LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.15.0-debian-11-r22" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/geode" \
      org.opencontainers.image.title="geode" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.15.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libc6 libgcc-s1 ncurses-bin procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.345-2" --checksum b244bc8c1f972d20fac8019cf97fb05ce6cd8be2034ca11f52243c8bd96aaa23
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-154" --checksum e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "geode" "1.15.0-5" --checksum 76f24efaa02b5ff08d5a1257ab0f37929181822e779fde438613610e48a83d32
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/geode/postunpack.sh
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV APP_VERSION="1.15.0" \
    BITNAMI_APP_NAME="geode" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:/opt/bitnami/geode/bin:$PATH"

EXPOSE 1099 7070 10334 40404

WORKDIR /opt/bitnami/geode
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/geode/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/geode/run.sh" ]
