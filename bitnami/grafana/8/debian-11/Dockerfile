FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libfontconfig procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "grafana" "8.5.4-0" --checksum ddbf902fa0b7ca76e57edf963258faa504e306d128fa4b7a8f505f3fc424f451
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum da4a2f759ccc57c100d795b71ab297f48b31c4dd7578d773d963bbd49c42bd7b
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/grafana/postunpack.sh
ENV APP_VERSION="8.5.4" \
    BITNAMI_APP_NAME="grafana" \
    PATH="/opt/bitnami/grafana/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 3000

WORKDIR /opt/bitnami/grafana
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/grafana/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/grafana/run.sh" ]
