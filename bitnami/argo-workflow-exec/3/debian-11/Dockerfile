FROM docker.io/bitnami/minideb:bullseye
ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="3.3.9-debian-11-r6" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/argo-workflow-exec" \
      org.opencontainers.image.title="argo-workflow-exec" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="3.3.9"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "kubectl" "1.23.10-1" --checksum 6d2e0264dffb930e101bcd82f0a09d90912352b0df92f418005828a49d50c006
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-154" --checksum e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "argo-workflow-exec" "3.3.9-1" --checksum 7eb3a02767cfc5cd6e1f451a49d5a2d19999874ae259f8c2d95ec27c1d232d5a
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
RUN /opt/bitnami/scripts/argo-workflow-exec/postunpack.sh
ENV APP_VERSION="3.3.9" \
    BITNAMI_APP_NAME="argo-workflow-exec" \
    PATH="/opt/bitnami/kubectl/bin:/opt/bitnami/common/bin:/opt/bitnami/argo-workflow-exec/bin:/opt/bitnami/argo-workflow-exec/hack:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/argo-workflow-exec/bin/argoexec" ]
CMD [ "help" ]
