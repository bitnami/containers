FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip iproute2 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.0-3" --checksum 8179ad1371c9a7d897fe3b1bf53bbe763f94edafef19acad2498dd48b3674efe
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-2" --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "consul" "1.9.4-0" --checksum bd353033d43531179f68112be69668d1d97e5e6dfec3801d2429e909349d0d81
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/consul/postunpack.sh
ENV BITNAMI_APP_NAME="consul" \
    BITNAMI_IMAGE_VERSION="1.9.4-debian-10-r23" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/consul/bin:$PATH"

EXPOSE 8300 8301 8500 8600

EXPOSE 8301/udp 8600/udp

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/consul/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/consul/run.sh" ]
