FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-exporter" "2.5.1-0" --checksum 764c2df3224b3443436a759f67fab0465e89757a2957cc156a69110ab3d25c8a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum da4a2f759ccc57c100d795b71ab297f48b31c4dd7578d773d963bbd49c42bd7b
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/harbor-exporter/postunpack.sh
ENV APP_VERSION="2.5.1" \
    BITNAMI_APP_NAME="harbor-exporter" \
    PATH="/opt/bitnami/harbor-exporter/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 9090

WORKDIR /opt/bitnami/harbor-exporter
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-exporter/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/harbor-exporter/run.sh" ]
