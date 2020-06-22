FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.7-1" --checksum e01669f15e2e655613c19eab1b8b533a720d6334766da34190a2a4939f5a0bc8
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "logstash" "7.8.0-0" --checksum 8cbcabd1990b15e848a98e259aaa1b153561651103e820e1e807eac3ee56d638
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-0" --checksum 582d501eeb6b338a24f417fededbf14295903d6be55c52d66c52e616c81bcd8c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
RUN /opt/bitnami/scripts/logstash/postunpack.sh
ENV BITNAMI_APP_NAME="logstash" \
    BITNAMI_IMAGE_VERSION="7.8.0-debian-10-r4" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/logstash/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/logstash
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/logstash/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/logstash/run.sh" ]
