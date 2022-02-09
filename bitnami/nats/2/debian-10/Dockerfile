FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-6" --checksum 81b0642a6d8e9d952a0f6540f2d7481a99b9a12dd42bcb5906ba8014ca80f326
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-3" --checksum 276ab5a0be4b05e136ec468d62c8f9cc4f40d9664c55f01f16a9f1209ba16980
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "nats" "2.7.2-0" --checksum 8f8a65849f9986a2c60d44fd6c0c4da6e36efbf065b141886c4f2f553dc87bbc
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/nats/postunpack.sh
ENV BITNAMI_APP_NAME="nats" \
    BITNAMI_IMAGE_VERSION="2.7.2-debian-10-r4" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/nats/bin:$PATH"

EXPOSE 4222 6222 8222

WORKDIR /opt/bitnami/nats
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/nats/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/nats/run.sh" ]
