FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 procps sudo unzip
RUN . ./libcomponent.sh && component_unpack "wait-for-port" "1.0.0-1" --checksum 07c4678654b01811f22b5bb65a8d6f8e253abd4524ebb3b78c7d3df042cf23bd
RUN . ./libcomponent.sh && component_unpack "redis" "5.0.7-1" --checksum 3707cee91ed431b7241c5ae7c5195f8ecdac99c388814b685f07b3b83651ad9b
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN useradd -r -u 1001 -g root redis
RUN /build/install-gosu.sh

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="redis" \
    BITNAMI_IMAGE_VERSION="5.0.7-debian-10-r47" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/redis/bin:$PATH"

EXPOSE 6379

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
