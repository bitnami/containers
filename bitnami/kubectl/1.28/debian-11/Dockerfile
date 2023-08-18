# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL com.vmware.cp.artifact.flavor="sha256:1e1b4657a77f0d47e9220f0c37b9bf7802581b93214fff7d1bd2364c8bf22e8e" \
      org.opencontainers.image.base.name="docker.io/bitnami/minideb:bullseye" \
      org.opencontainers.image.created="2023-08-18T18:27:32Z" \
      org.opencontainers.image.description="Application packaged by VMware, Inc" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="1.28.0-debian-11-r26" \
      org.opencontainers.image.title="kubectl" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.28.0"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl git jq procps
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    COMPONENTS=( \
      "v1.28.0" \
    ) && \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://cdn.dl.k8s.io/release/${COMPONENT}/bin/linux/amd64/kubectl" -O ; \
        curl -SsLf "https://cdn.dl.k8s.io/release/${COMPONENT}/bin/linux/amd64/kubectl.sha256" -O ; \
      fi && \
      echo "`cat kubectl.sha256` ./kubectl" | sha256sum -c && \
      chmod +x kubectl && \
      mkdir -p /opt/bitnami/kubectl/bin && \
      cp kubectl /opt/bitnami/kubectl/bin && \
      rm -rf kubectl{,.sha256} ; \
    done
RUN apt-get autoremove --purge -y curl && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /.kube && chmod g+rwX /.kube

ENV APP_VERSION="1.28.0" \
    BITNAMI_APP_NAME="kubectl" \
    PATH="/opt/bitnami/kubectl/bin:$PATH"

USER 1001
ENTRYPOINT [ "kubectl" ]
CMD [ "--help" ]
