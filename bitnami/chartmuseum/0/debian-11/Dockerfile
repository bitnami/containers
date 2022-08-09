FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-153" --checksum d3ae0109be24e8bc56f97359b8290b91243454de946dd60bd8520a0896a88449
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "chartmuseum" "0.15.0-1" --checksum 93beec9b38a2a3532d00225ca12f649ee363708b98edf84295a0dcfe10c0e98d
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/chartmuseum/postunpack.sh
ENV APP_VERSION="0.15.0" \
    BITNAMI_APP_NAME="chartmuseum" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/chartmuseum/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/chartmuseum/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/chartmuseum/run.sh" ]
