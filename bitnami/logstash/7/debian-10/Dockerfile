FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 libgcc1 procps sudo unzip
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "logstash" "7.6.2-0" --checksum dcdbdd15a9fda4c2ef971a28c96497e02bd3da6292abd014d0ace6bd48754302
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.252-0" --checksum d7271eff41b312b73aea7aea3b79a6b1a69cf6613804803daff952aff7d440b4
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-0" --checksum 582d501eeb6b338a24f417fededbf14295903d6be55c52d66c52e616c81bcd8c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
RUN /opt/bitnami/scripts/logstash/postunpack.sh
ENV BITNAMI_APP_NAME="logstash" \
    BITNAMI_IMAGE_VERSION="7.6.2-debian-10-r32" \
    PATH="/opt/bitnami/logstash/bin:/opt/bitnami/java/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/logstash
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/logstash/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/logstash/run.sh" ]
