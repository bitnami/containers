FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-exporter" "2.5.3-1" --checksum 9e8ef8d294feab783c00a85b1262457fb3904b23bddc4142a81944b9c9fba4bf
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-152" --checksum 0c751c7e2ec0bc900a19dbec0306d6294fe744ddfb0fa64197ba1a36040092f0
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/harbor-exporter/postunpack.sh
ENV APP_VERSION="2.5.3" \
    BITNAMI_APP_NAME="harbor-exporter" \
    PATH="/opt/bitnami/harbor-exporter/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 9090

WORKDIR /opt/bitnami/harbor-exporter
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-exporter/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/harbor-exporter/run.sh" ]
