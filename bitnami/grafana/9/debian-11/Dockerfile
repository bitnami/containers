FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="9.1.0-debian-11-r1" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/grafana" \
      org.opencontainers.image.title="grafana" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="9.1.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libfontconfig procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "grafana" "9.1.0-0" --checksum b48c0bda1ca39d061bf92cf3f77301832e4821f0683e54dd7cd1047cd06aa828
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-153" --checksum d3ae0109be24e8bc56f97359b8290b91243454de946dd60bd8520a0896a88449
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/grafana/postunpack.sh
ENV APP_VERSION="9.1.0" \
    BITNAMI_APP_NAME="grafana" \
    PATH="/opt/bitnami/grafana/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 3000

WORKDIR /opt/bitnami/grafana
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/grafana/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/grafana/run.sh" ]
