# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG TARGETARCH

LABEL com.vmware.cp.artifact.flavor="sha256:c50c90cfd9d12b445b011e6ad529f1ad3daea45c26d20b00732fae3cd71f6a83" \
      org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2024-06-05T01:45:07Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/metallb-speaker/README.md" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="0.14.5-debian-12-r7" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/metallb-speaker" \
      org.opencontainers.image.title="metallb-speaker" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="0.14.5"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps tcpdump
RUN mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ ; \
    COMPONENTS=( \
      "metallb-speaker-0.14.5-4-linux-${OS_ARCH}-debian-12" \
    ) ; \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz.sha256" -O ; \
      fi ; \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" ; \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' ; \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done
RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true
RUN curl -sLO "https://deb.frrouting.org/frr/pool/frr-9.1/f/frr/frr_9.1-0~deb12u1_${OS_ARCH}.deb" && \
    curl -sLO "https://deb.frrouting.org/frr/pool/frr-9.1/f/frr/frr-pythontools_9.1-0~deb12u1_all.deb" && \
    if [ "$OS_ARCH" = "amd64" ]; then \
      echo "96a180d90d1d2f5ddcab07919237abe3f4271f54caddc21982c2b5fc6fe0ebba  frr_9.1-0~deb12u1_${OS_ARCH}.deb" | sha256sum -c - ; \
    else \
      echo "0769587460a8f483f286e3642ec7c6527a73781745508e546bfdf4d2582dc7bb  frr_9.1-0~deb12u1_${OS_ARCH}.deb" | sha256sum -c - ; \
    fi && \
    echo "1aa6f93d39a6384b01d9492b034cea93cf46fb54ea078a7c9194319264076fed  frr-pythontools_9.1-0~deb12u1_all.deb" | sha256sum -c - && \
    install_packages "./frr_9.1-0~deb12u1_${OS_ARCH}.deb" "./frr-pythontools_9.1-0~deb12u1_all.deb" && \
    rm frr_9.1-0~deb12u1_${OS_ARCH}.deb frr-pythontools_9.1-0~deb12u1_all.deb

ENV APP_VERSION="0.14.5" \
    BITNAMI_APP_NAME="metallb-speaker" \
    PATH="/opt/bitnami/metallb-speaker/bin:$PATH"

USER 1001
ENTRYPOINT [ "speaker" ]
CMD [ "--help" ]
