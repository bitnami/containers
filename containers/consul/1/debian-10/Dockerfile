FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps sudo unzip
RUN . ./libcomponent.sh && component_unpack "render-template" "1.0.0-0" --checksum 63449e5ed4ece61d7bbeda0d173b68768d9fb444922b8ffa2e1042be20687142
RUN . ./libcomponent.sh && component_unpack "consul" "1.7.1-0" --checksum cf432a3e033ee1294f1b40673b8547dfdaa44c8e1948114cf2ce8977e2faa7c9
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/install-gosu.sh

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="consul" \
    BITNAMI_IMAGE_VERSION="1.7.1-debian-10-r11" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/consul/bin:$PATH"

EXPOSE 8300 8301 8500 8600

EXPOSE 8301/udp 8600/udp

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
