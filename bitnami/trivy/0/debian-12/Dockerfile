# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm AS builder

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

ENV OS_ARCH="${TARGETARCH:-amd64}"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl
RUN --mount=type=secret,id=downloads_url,env=SECRET_DOWNLOADS_URL \
    DOWNLOADS_URL=${SECRET_DOWNLOADS_URL:-${DOWNLOADS_URL}} ; \
    mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ || exit 1 ; \
    COMPONENTS=( \
      "trivy-0.67.1-0-linux-${OS_ARCH}-debian-12" \
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
RUN mkdir -p /opt/bitnami/rootfs/.cache && chmod g+rwX /opt/bitnami/rootfs/.cache
RUN mkdir -p /opt/bitnami/rootfs/tmp && chmod g+rwX /opt/bitnami/rootfs/tmp
RUN uninstall_packages curl

######

FROM scratch

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

ENV OS_ARCH="${TARGETARCH:-amd64}"

LABEL org.opencontainers.image.base.name="scratch" \
      org.opencontainers.image.created="2025-10-09T12:43:35Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.title="trivy" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="0.67.1"

COPY rootfs /
COPY --from=builder /opt/bitnami/rootfs /
COPY --from=builder /opt/bitnami/trivy/.spdx-trivy.spdx /opt/bitnami/trivy/.spdx-trivy.spdx
COPY --from=builder /opt/bitnami/trivy/bin/trivy /opt/bitnami/trivy/bin/trivy
COPY --from=builder /opt/bitnami/trivy/contrib /opt/bitnami/trivy/contrib
COPY --from=builder /opt/bitnami/trivy/licenses /opt/bitnami/trivy/licenses

ENV APP_VERSION="0.67.1" \
    BITNAMI_APP_NAME="trivy" \
    IMAGE_REVISION="0" \
    PATH="/opt/bitnami/trivy/bin:$PATH"

WORKDIR /opt/bitnami/trivy

USER 1001

ENTRYPOINT [ "trivy" ]

CMD [ "--help" ]
