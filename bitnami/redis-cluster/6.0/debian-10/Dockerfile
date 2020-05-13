FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 procps sudo unzip
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "redis" "6.0.1-0" --checksum 5dfdb422094309ccb5ff1b8fa7da149e272bad797eb5e77b2baf0fbdcfe4f69b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-0" --checksum 582d501eeb6b338a24f417fededbf14295903d6be55c52d66c52e616c81bcd8c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="redis" \
    BITNAMI_IMAGE_VERSION="6.0.1-debian-10-r0" \
    PATH="/opt/bitnami/redis/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 6379

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
