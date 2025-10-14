# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2025-10-14T04:15:15Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/metallb-speaker/README.md" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/metallb-speaker" \
      org.opencontainers.image.title="metallb-speaker" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="0.15.2"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps tcpdump
RUN --mount=type=secret,id=downloads_url,env=SECRET_DOWNLOADS_URL \
    DOWNLOADS_URL=${SECRET_DOWNLOADS_URL:-${DOWNLOADS_URL}} ; \
    mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ || exit 1 ; \
    COMPONENTS=( \
      "metallb-speaker-0.15.2-8-linux-${OS_ARCH}-debian-12" \
    ) ; \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://${DOWNLOADS_URL}/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://${DOWNLOADS_URL}/${COMPONENT}.tar.gz.sha256" -O ; \
      fi ; \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" ; \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner ; \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done
RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true
RUN curl -sLO "https://deb.frrouting.org/frr/pool/frr-9.1/f/frr/frr_9.1.3-0~deb12u1_${OS_ARCH}.deb" && \
    curl -sLO "https://deb.frrouting.org/frr/pool/frr-9.1/f/frr/frr-pythontools_9.1.3-0~deb12u1_all.deb" && \
    curl -sLO "https://deb.frrouting.org/frr/pool/frr-9.1/liby/libyang2/libyang2_2.1.128-2~deb12u1_${OS_ARCH}.deb" && \
    if [ "$OS_ARCH" = "amd64" ]; then \
      echo "7e22b1cf91359a604af68df9fea4313d6bdf854a9ab731e5f3e8543102bd1dd5  frr_9.1.3-0~deb12u1_${OS_ARCH}.deb" | sha256sum -c - ; \
      echo "62380f148e22c87d91bf24d0ef74484bf592922fbe891a6d62ddcedd19dd9311  libyang2_2.1.128-2~deb12u1_${OS_ARCH}.deb" | sha256sum -c - ; \
    else \
      echo "745e5939fe1c64fa7a1ac3c46185e3e3952e976ac77d3e7f51707fb5463e8dbd  frr_9.1.3-0~deb12u1_${OS_ARCH}.deb" | sha256sum -c - ; \
      echo "0e10ece05bab6b777bfac13d62f71b61e504f64d74ce35746dd3abd6c05beb4b  libyang2_2.1.128-2~deb12u1_${OS_ARCH}.deb" | sha256sum -c - ; \
    fi && \
    echo "43a8aa4c029e779113b7edf4b2d04f29c8f7d74614096a6862dfb4b9ff9694f2  frr-pythontools_9.1.3-0~deb12u1_all.deb" | sha256sum -c - && \
    install_packages "./frr_9.1.3-0~deb12u1_${OS_ARCH}.deb" "./frr-pythontools_9.1.3-0~deb12u1_all.deb" "./libyang2_2.1.128-2~deb12u1_${OS_ARCH}.deb" && \
    rm frr_9.1.3-0~deb12u1_${OS_ARCH}.deb frr-pythontools_9.1.3-0~deb12u1_all.deb libyang2_2.1.128-2~deb12u1_${OS_ARCH}.deb

ENV APP_VERSION="0.15.2" \
    BITNAMI_APP_NAME="metallb-speaker" \
    IMAGE_REVISION="11" \
    PATH="/opt/bitnami/metallb-speaker/bin:$PATH"

USER 1001
ENTRYPOINT [ "speaker" ]
CMD [ "--help" ]
