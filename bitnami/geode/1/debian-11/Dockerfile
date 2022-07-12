FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libc6 libgcc-s1 ncurses-bin procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.333-152" --checksum 1f4d76b18ae5c1952c991332f02bd79c3979be7a7038923cdc4e7d8bfe3705e3
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-151" --checksum 089bb11a3bc6031c5a91ab5f9534e9e7e41b928d10d72a3986f16bb61d3a9900
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "geode" "1.15.0-0" --checksum d46792ed1d3e4fd594d665e2fecb41e0fc695d9103d2265b7b598884e74327c2
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
