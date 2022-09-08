FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="11-debian-11-r33" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/bitnami-shell" \
      org.opencontainers.image.title="bitnami-shell" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="11"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages curl procps
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

ENV APP_VERSION="11" \
    BITNAMI_APP_NAME="bitnami-shell" \
    HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

USER 1001
