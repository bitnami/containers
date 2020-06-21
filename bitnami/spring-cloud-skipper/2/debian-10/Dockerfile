FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libgcc1 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.252-3" --checksum 8631fe0cc0887a566e878939cf8cd58650be5d5de23f3c6f94fffb258aadeb3a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "3.3.2-0" --checksum 50cac57ffd984455e7321d1f13380f94b6bda2a16b7e2547ba33aad347d5e9eb
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "spring-cloud-skipper" "2.4.1-0" --checksum 56358241bd5a0d09eee6b991efd6d2f78e76ffe5e5f2edc58bc21a84ea0dde86
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-0" --checksum 582d501eeb6b338a24f417fededbf14295903d6be55c52d66c52e616c81bcd8c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
RUN /opt/bitnami/scripts/spring-cloud-skipper/postunpack.sh
ENV BITNAMI_APP_NAME="spring-cloud-skipper" \
    BITNAMI_IMAGE_VERSION="2.4.1-debian-10-r5" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/spring-cloud-skipper/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/spring-cloud-skipper/run.sh" ]
