FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/java/bin:/opt/bitnami/zookeeper/bin:$PATH"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="3.8.0-debian-11-r31" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/zookeeper" \
      org.opencontainers.image.title="zookeeper" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="3.8.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 netcat procps tar xmlstarlet zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.3-153" --checksum 8c8e324ab6e7b7d76b4655182d6ea5f6550edfc9e32bec92228e678c26fc8b16
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.15-1-2" --checksum 1a5468c7b552dfc8a33c5c9b214dbf7dd143a5f008cc3aa2e0418fab5eb16c5c
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-153" --checksum d3ae0109be24e8bc56f97359b8290b91243454de946dd60bd8520a0896a88449
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "zookeeper" "3.8.0-154" --checksum 5bcb56a155f1b1564330f81091d84fa6f9127f6f072eb89016aa73ad51f699ef
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/scripts/zookeeper/entrypoint.sh /entrypoint.sh
RUN ln -s /opt/bitnami/scripts/zookeeper/run.sh /run.sh

COPY rootfs /
RUN /opt/bitnami/scripts/zookeeper/postunpack.sh
ENV APP_VERSION="3.8.0" \
    BITNAMI_APP_NAME="zookeeper"

EXPOSE 2181 2888 3888 8080

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/zookeeper/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/zookeeper/run.sh" ]
