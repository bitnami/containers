FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-3" --checksum cddf51b3cb59d65d5d30e3fe37e99d8d53375ad88f0cc474019a52e6d8b4fc58
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "nats" "2.6.5-0" --checksum 7f49e313fc37800a679cf1eb83961e5128eb8ef0dafb7cf1455674c51e7ad062
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/nats/postunpack.sh
ENV BITNAMI_APP_NAME="nats" \
    BITNAMI_IMAGE_VERSION="2.6.5-debian-10-r8" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/nats/bin:$PATH"

EXPOSE 4222 6222 8222

WORKDIR /opt/bitnami/nats
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/nats/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/nats/run.sh" ]
