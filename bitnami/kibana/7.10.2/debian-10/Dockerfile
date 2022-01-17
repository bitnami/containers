FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/kibana/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libgcc1 libstdc++6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.16.2-2" --checksum 1c135708aaa8cb69936471de63563de08e97b7d0bfb4126d41b54a149557c5c0
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-1" --checksum 16f1a317859b06ae82e816b30f98f28b4707d18fe6cc3881bff535192a7715dc
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "kibana" "7.10.2-4" --checksum 1f734461c886bda770636fb7efec86fba318a4198667ae1a8064ad785b4fa85d
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/kibana/postunpack.sh
ENV BITNAMI_APP_NAME="kibana" \
    BITNAMI_IMAGE_VERSION="7.10.2-debian-10-r325"

EXPOSE 5601

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/kibana/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/kibana/run.sh" ]
