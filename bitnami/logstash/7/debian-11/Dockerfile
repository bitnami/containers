FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.15-1-0" --checksum 036b876a7a2546e5639cb5557d152ec14a3492ca37132dc99e8bd2e3b8ce1ecd
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.25.3-2" --checksum 84ce4016efca8b6a6713d69e9d7c19003d4a530f8b420fb8cdcaa9cf9af47ee6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "logstash" "7.17.5-1" --checksum c17f6fc756c25b74cd978dc4c39d94eb12392590a383f9f1e27f78bef09919d1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-151" --checksum 089bb11a3bc6031c5a91ab5f9534e9e7e41b928d10d72a3986f16bb61d3a9900
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/logstash/postunpack.sh
ENV APP_VERSION="7.17.5" \
    BITNAMI_APP_NAME="logstash" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:/opt/bitnami/logstash/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/logstash
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/logstash/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/logstash/run.sh" ]
