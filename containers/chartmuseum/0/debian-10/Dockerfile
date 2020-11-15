FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-2" --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "chartmuseum" "0.12.0-1" --checksum fcf733ec59494c7253fec8a69a62a105de07efe57b0a9f2b5cbbca900b5f1044
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/chartmuseum/postunpack.sh
ENV BITNAMI_APP_NAME="chartmuseum" \
    BITNAMI_IMAGE_VERSION="0.12.0-debian-10-r208" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/chartmuseum/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/chartmuseum/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/chartmuseum/run.sh" ]
