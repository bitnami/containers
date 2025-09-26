# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# Build stage
FROM alpine:latest AS builder
RUN apk add --no-cache gcc g++ musl-dev make tar curl ca-certificates linux-headers
RUN cd /tmp && \
    curl -k -fsSL https://download.redis.io/redis-stable.tar.gz | tar xz && \
    cd redis-stable && \
    make MALLOC=libc LDFLAGS=-static && \
    make install PREFIX=/opt/bitnami

# Final stage
FROM photon:5.0

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2025-09-07T02:35:10Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/redis/README.md" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/redis" \
      org.opencontainers.image.title="redis" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="8.2.1"

ENV HOME="/" \
  OS_ARCH="${TARGETARCH:-amd64}" \
  OS_FLAVOUR="ubuntu-22.04" \
  OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Disable problematic updates repo and install packages from base repo only
RUN sed -i '/Updates/,/^$/d' /etc/yum.repos.d/photon.repo && \
    tdnf install -y --nogpgcheck ca-certificates curl && \
    tdnf clean all
# Copy Redis binaries from builder stage
COPY --from=builder /opt/bitnami /opt/bitnami
RUN mkdir -p /opt/bitnami/scripts/redis /opt/bitnami/redis/bin && \
    ln -s /opt/bitnami/bin/redis-server /opt/bitnami/redis/bin/redis-server && \
    ln -s /opt/bitnami/bin/redis-cli /opt/bitnami/redis/bin/redis-cli

# Create basic entrypoint and run scripts
RUN echo '#!/bin/bash' > /opt/bitnami/scripts/redis/entrypoint.sh && \
    echo 'exec "$@"' >> /opt/bitnami/scripts/redis/entrypoint.sh && \
    echo '#!/bin/bash' > /opt/bitnami/scripts/redis/run.sh && \
    echo 'exec /opt/bitnami/bin/redis-server --daemonize no' >> /opt/bitnami/scripts/redis/run.sh && \
    chmod +x /opt/bitnami/scripts/redis/entrypoint.sh /opt/bitnami/scripts/redis/run.sh
RUN tdnf upgrade -y --nogpgcheck && tdnf clean all
RUN chmod g+rwX /opt/bitnami
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true
RUN ln -s /opt/bitnami/scripts/redis/entrypoint.sh /entrypoint.sh
RUN ln -s /opt/bitnami/scripts/redis/run.sh /run.sh
RUN tdnf remove -y curl && tdnf clean all


# COPY rootfs /
# RUN /opt/bitnami/scripts/redis/postunpack.sh
ENV BITNAMI_APP_NAME="redis" \
  IMAGE_REVISION="1" \
  PATH="/opt/bitnami/common/bin:/opt/bitnami/redis/bin:$PATH"

EXPOSE 6379

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/redis/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/redis/run.sh" ]