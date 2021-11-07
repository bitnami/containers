FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip iproute2 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-1" --checksum 00722b62c7561929e039877a6e445a4bb782c340890c0a090fdae3c9e1960161
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "consul" "1.10.3-0" --checksum 9c212374bb3d1aeae9cd1a6753993acc5cb212e0745a9bf01ff2b47f6ec2481d
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/consul/postunpack.sh
ENV BITNAMI_APP_NAME="consul" \
    BITNAMI_IMAGE_VERSION="1.10.3-debian-10-r36" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/consul/bin:$PATH"

EXPOSE 8300 8301 8500 8600

EXPOSE 8301/udp 8600/udp

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/consul/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/consul/run.sh" ]
