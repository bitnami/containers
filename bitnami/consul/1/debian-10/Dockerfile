FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip iproute2 procps tar zlib1g-dev
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-6" --checksum 81b0642a6d8e9d952a0f6540f2d7481a99b9a12dd42bcb5906ba8014ca80f326
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-3" --checksum 276ab5a0be4b05e136ec468d62c8f9cc4f40d9664c55f01f16a9f1209ba16980
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "consul" "1.11.2-2" --checksum 0787d204c49b3132a412d2e5e1945463be40caa3d430f88053064a85a84a47e1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/consul/postunpack.sh
ENV BITNAMI_APP_NAME="consul" \
    BITNAMI_IMAGE_VERSION="1.11.2-debian-10-r14" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/consul/bin:$PATH"

EXPOSE 8300 8301 8500 8600

EXPOSE 8301/udp 8600/udp

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/consul/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/consul/run.sh" ]
