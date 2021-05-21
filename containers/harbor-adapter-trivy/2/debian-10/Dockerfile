FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 procps rpm tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-adapter-trivy" "2.2.2-0" --checksum 481f43d0fa49186a58f49d81a38a07ea5f6a52ae7bc55b199d7984549b851e3d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-2" --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/harbor-adapter-trivy/postunpack.sh
ENV BITNAMI_APP_NAME="harbor-adapter-trivy" \
    BITNAMI_IMAGE_VERSION="2.2.2-debian-10-r1" \
    PATH="/opt/bitnami/harbor-adapter-trivy/bin:/opt/bitnami/common/bin:$PATH"

WORKDIR /opt/bitnami/harbor-adapter-trivy
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-adapter-trivy/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/harbor-adapter-trivy/run.sh" ]
