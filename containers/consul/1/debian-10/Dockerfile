FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip iproute2 procps tar zlib1g-dev
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.3-0" --checksum af5ec81cfb8e8420fe6af80a77d40da25e0f7e136abb6dde27267c97fb27cf8b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "consul" "1.12.2-0" --checksum 6861f0e5697c3bd62d4ada2be08372425edecfcf1b1f435e34afdc1883caf9bd
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/consul/postunpack.sh
ENV APP_VERSION="1.12.2" \
    BITNAMI_APP_NAME="consul" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/consul/bin:$PATH"

EXPOSE 8300 8301 8500 8600

EXPOSE 8301/udp 8600/udp

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/consul/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/consul/run.sh" ]
