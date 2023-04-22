FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL com.vmware.cp.artifact.flavor="sha256:109c7d51bd69bb6b3df71017440c1ea0699454f81fe188056c083f0b57c96ea6" \
      org.opencontainers.image.base.name="docker.io/bitnami/minideb:bullseye" \
      org.opencontainers.image.created="2023-04-22T19:40:47Z" \
      org.opencontainers.image.description="Application packaged by VMware, Inc" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="11-debian-11-r109" \
      org.opencontainers.image.title="bitnami-shell" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="11"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages curl procps
RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV APP_VERSION="11" \
    BITNAMI_APP_NAME="bitnami-shell" \
    HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

USER 1001
