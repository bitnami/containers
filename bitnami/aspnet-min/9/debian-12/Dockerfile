# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm AS builder

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

ENV OS_ARCH="${TARGETARCH:-amd64}"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl jq libc6 libgcc-s1 libgomp1 libicu72 libssl3 libstdc++6 netbase openssl rsync sed tzdata
RUN mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ || exit 1 ; \
    COMPONENTS=( \
      "aspnet-min-9.0.4-1-linux-${OS_ARCH}-debian-12" \
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

RUN /opt/bitnami/scripts/aspnet/postunpack.sh
RUN /opt/bitnami/scripts/generate-spdx.sh libicu72 && mv /opt/bitnami/os/.spdx-os.spdx /opt/bitnami/os/.spdx-os-aspnet-min.spdx
RUN /opt/bitnami/scripts/static/postunpack.sh
RUN /opt/bitnami/scripts/libgcc/postunpack.sh
RUN /opt/bitnami/scripts/generate-spdx.sh libc6 openssl libssl3 libgomp1 openssl libssl3 libgomp libstdc++6 libgcc-s1 && mv /opt/bitnami/os/.spdx-os.spdx /opt/bitnami/os/.spdx-os-libgcc.spdx
RUN /opt/bitnami/scripts/generate-spdx.sh tzdata ca-certificates netbase && mv /opt/bitnami/os/.spdx-os.spdx /opt/bitnami/os/.spdx-os-static.spdx

######

FROM scratch

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

ENV OS_ARCH="${TARGETARCH:-amd64}"

LABEL com.vmware.cp.artifact.flavor="sha256:c50c90cfd9d12b445b011e6ad529f1ad3daea45c26d20b00732fae3cd71f6a83" \
      org.opencontainers.image.base.name="scratch" \
      org.opencontainers.image.created="2025-04-09T13:00:23Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.ref.name="9.0.4-debian-12-r1" \
      org.opencontainers.image.title="aspnet-min" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="9.0.4"

COPY --from=builder /opt/bitnami/aspnet/.spdx-aspnet-min.spdx /opt/bitnami/aspnet/.spdx-aspnet-min.spdx
COPY --from=builder /opt/bitnami/aspnet/bin/dotnet /opt/bitnami/aspnet/bin/dotnet
COPY --from=builder /opt/bitnami/aspnet/bin/host /opt/bitnami/aspnet/bin/host
COPY --from=builder /opt/bitnami/aspnet/bin/shared /opt/bitnami/aspnet/bin/shared
COPY --from=builder /opt/bitnami/aspnet/licenses /opt/bitnami/aspnet/licenses
COPY --from=builder /opt/bitnami/os/.spdx-os-aspnet-min.spdx /opt/bitnami/os/.spdx-os-aspnet-min.spdx
COPY --from=builder /opt/bitnami/os/.spdx-os-libgcc.spdx /opt/bitnami/os/.spdx-os-libgcc.spdx
COPY --from=builder /opt/bitnami/os/.spdx-os-static.spdx /opt/bitnami/os/.spdx-os-static.spdx
COPY --from=builder /rootfs /

ENV APP_VERSION="9.0.4" \
    BITNAMI_APP_NAME="aspnet-min" \
    PATH="/opt/bitnami/aspnet/bin:$PATH"

WORKDIR /app

ENTRYPOINT [ "/opt/bitnami/aspnet/bin/dotnet" ]
