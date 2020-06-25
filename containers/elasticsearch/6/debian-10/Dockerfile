FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:/opt/bitnami/elasticsearch/bin:$PATH"

ARG ELASTICSEARCH_PLUGINS=""

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip hostname libc6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.7-2" --checksum a79c3f491f7d2f730fbcad82b1c61f496e44b07a7bd87a13478b14ae90ef3e22
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "3.3.2-0" --checksum 50cac57ffd984455e7321d1f13380f94b6bda2a16b7e2547ba33aad347d5e9eb
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-1" --checksum 51cfb1b7fd7b05b8abd1df0278c698103a9b1a4964bdacd87ca1d5c01631d59c
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "elasticsearch" "6.8.10-0" --checksum d2b43555e358fe2daa533d73707b9da012b0a6b2e71f4aec059e347d3ad06993
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
RUN /opt/bitnami/scripts/elasticsearch/postunpack.sh
ENV BITNAMI_APP_NAME="elasticsearch" \
    BITNAMI_IMAGE_VERSION="6.8.10-debian-10-r18" \
    LD_LIBRARY_PATH="/opt/bitnami/elasticsearch/jdk/lib:/opt/bitnami/elasticsearch/jdk/lib/server:$LD_LIBRARY_PATH"

EXPOSE 9200 9300

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/elasticsearch/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/elasticsearch/run.sh" ]
