FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-exporter" "2.4.2-2" --checksum 97a98b76b082423b013f0b16169ba0235518896eb9a7aaf927b1a43d035ae81a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/harbor-exporter/postunpack.sh
ENV APP_VERSION="2.4.2" \
    BITNAMI_APP_NAME="harbor-exporter" \
    BITNAMI_IMAGE_VERSION="2.4.2-debian-10-r13" \
    PATH="/opt/bitnami/harbor-exporter/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 9090

WORKDIR /opt/bitnami/harbor-exporter
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-exporter/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/harbor-exporter/run.sh" ]
