FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-adapter-clair" "2.3.3-0" --checksum f5f1fe3b5d56f124a046dce7d708ee8c2012034d76f7ab23f31ae5363bc6a763
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/harbor-adapter-clair/postunpack.sh
ENV BITNAMI_APP_NAME="harbor-adapter-clair" \
    BITNAMI_IMAGE_VERSION="2.3.3-debian-10-r1" \
    PATH="/opt/bitnami/harbor-adapter-clair/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/harbor-adapter-clair
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-adapter-clair/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/harbor-adapter-clair/run.sh" ]
