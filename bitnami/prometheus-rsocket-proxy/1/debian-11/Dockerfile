# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL com.vmware.cp.artifact.flavor="sha256:1e1b4657a77f0d47e9220f0c37b9bf7802581b93214fff7d1bd2364c8bf22e8e" \
      org.opencontainers.image.base.name="docker.io/bitnami/minideb:bullseye" \
      org.opencontainers.image.created="2024-01-08T02:18:27Z" \
      org.opencontainers.image.description="Application packaged by VMware, Inc" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="1.5.3-debian-11-r2" \
      org.opencontainers.image.title="prometheus-rsocket-proxy" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.5.3"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libgcc-s1 procps
RUN mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ ; \
    COMPONENTS=( \
      "java-1.8.392-9-8-linux-${OS_ARCH}-debian-11" \
      "prometheus-rsocket-proxy-1.5.3-0-linux-${OS_ARCH}-debian-11" \
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
RUN apt-get autoremove --purge -y curl && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN touch /opt/bitnami/prometheus-rsocket-proxy/prometheus-rsocket-proxy.log && chmod -R g+rwX /opt/bitnami/prometheus-rsocket-proxy

ENV APP_VERSION="1.5.3" \
    BITNAMI_APP_NAME="prometheus-rsocket-proxy" \
    PATH="/opt/bitnami/java/bin:$PATH"

WORKDIR /opt/bitnami/prometheus-rsocket-proxy
USER 1001
ENTRYPOINT [ "/opt/bitnami/java/bin/java", "-jar", "/opt/bitnami/prometheus-rsocket-proxy/prometheus-rsocket-proxy.jar" ]
