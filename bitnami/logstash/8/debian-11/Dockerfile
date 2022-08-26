FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"
LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="8.3.3-debian-11-r10" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/logstash" \
      org.opencontainers.image.title="logstash" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="8.3.3"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.15-1-2" --checksum 1a5468c7b552dfc8a33c5c9b214dbf7dd143a5f008cc3aa2e0418fab5eb16c5c
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.27.2-1" --checksum 44d0058c0fffa1ccc89c081ed3e5c897489fa02580a839cfe1d37b2ca771f237
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "logstash" "8.3.3-1" --checksum e3cb17c398a39e64473e9606d32a0df3529b8e5e4af6673d520a0271a59c731e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-153" --checksum d3ae0109be24e8bc56f97359b8290b91243454de946dd60bd8520a0896a88449
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/logstash/postunpack.sh
ENV APP_VERSION="8.3.3" \
    BITNAMI_APP_NAME="logstash" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:/opt/bitnami/logstash/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/logstash
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/logstash/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/logstash/run.sh" ]
