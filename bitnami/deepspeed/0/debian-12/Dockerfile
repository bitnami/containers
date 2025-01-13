# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

LABEL com.vmware.cp.artifact.flavor="sha256:c50c90cfd9d12b445b011e6ad529f1ad3daea45c26d20b00732fae3cd71f6a83" \
      org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2025-01-11T18:19:26Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/deepspeed/README.md" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="0.16.2-debian-12-r1" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/deepspeed" \
      org.opencontainers.image.title="deepspeed" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="0.16.2"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl git jq libbz2-1.0 libcom-err2 libcrypt1 libffi8 libgcc-s1 libgomp1 libgssapi-krb5-2 libjemalloc2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblzma5 libncursesw6 libnsl2 libreadline8 libsqlite3-0 libssl3 libstdc++6 libtinfo6 libtirpc3 libuuid1 numactl openssh-server pkg-config procps unzip zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ ; \
    COMPONENTS=( \
      "render-template-1.0.7-8-linux-${OS_ARCH}-debian-12" \
      "python-3.11.11-1-linux-${OS_ARCH}-debian-12" \
      "deepspeed-0.16.2-0-linux-${OS_ARCH}-debian-12" \
    ) ; \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://${DOWNLOADS_URL}/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://${DOWNLOADS_URL}/${COMPONENT}.tar.gz.sha256" -O ; \
      fi ; \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" ; \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' ; \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done
RUN apt-get autoremove --purge -y curl && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN useradd -r -u 1001 -g root deepspeed
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true
RUN mkdir /.local && chmod g+rwX /.local

COPY rootfs /
RUN mkdir /app /.cache && mkdir -p /home/deepspeed/.local && mkdir -p /home/deepspeed/.ssh && mkdir /home/deepspeed/.cache && ln -s /home/deepspeed/.local /opt/bitnami/deepspeed && ln -s /home/deepspeed/.ssh /opt/bitnami/deepspeed && ln -s /home/deepspeed/.cache /opt/bitnami/deepspeed && chmod g+rwX /app /.cache /home/deepspeed/.cache /home/deepspeed/.local
ENV APP_VERSION="0.16.2" \
    BITNAMI_APP_NAME="deepspeed" \
    CFLAGS="-s -I/opt/bitnami/python/include -I/opt/bitnami/common/include" \
    CPLUS_INCLUDE_PATH="/opt/bitnami/common/include" \
    CPPFLAGS="-I/opt/bitnami/python/include -I/opt/bitnami/common/include" \
    C_INCLUDE_PATH="/opt/bitnami/common/include" \
    LDFLAGS="-Wl,-rpath: /opt/bitnami/python/lib -L/opt/bitnami/python/lib -Wl,-rpath: /opt/bitnami/common/lib -L/opt/bitnami/common/lib" \
    LD_LIBRARY_PATH="/opt/bitnami/python/lib:/opt/bitnami/common/lib:${LD_LIBRARY_PATH}" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/python/bin:$PATH" \
    TRITON_CACHE_DIR="/opt/bitnami/deepspeed"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/deepspeed/entrypoint.sh" ]
CMD [ "python" ]
