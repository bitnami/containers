FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.13.0-0" --checksum fd7257c2736164d02832dbf72e2c1ed9d875bf3e32f0988520796bc503330129
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "chartmuseum" "0.13.1-2" --checksum de10f2d7e5c4832c487630f55d1dd1bde770586c31392d4c664eb434a001badf
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/chartmuseum/postunpack.sh
ENV BITNAMI_APP_NAME="chartmuseum" \
    BITNAMI_IMAGE_VERSION="0.13.1-debian-10-r114" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/chartmuseum/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/chartmuseum/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/chartmuseum/run.sh" ]
