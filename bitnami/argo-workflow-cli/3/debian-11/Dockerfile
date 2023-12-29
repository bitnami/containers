# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bullseye as builder

ARG TARGETARCH

ENV OS_ARCH="${TARGETARCH:-amd64}"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl
RUN mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ ; \
    COMPONENTS=( \
      "argo-workflows-3.5.2-4-linux-${OS_ARCH}-debian-11" \
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

######

FROM scratch

ARG TARGETARCH

ENV OS_ARCH="${TARGETARCH:-amd64}"

LABEL com.vmware.cp.artifact.flavor="sha256:1e1b4657a77f0d47e9220f0c37b9bf7802581b93214fff7d1bd2364c8bf22e8e" \
      org.opencontainers.image.base.name="scratch" \
      org.opencontainers.image.created="2023-12-29T13:06:44Z" \
      org.opencontainers.image.description="Application packaged by VMware, Inc" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="3.5.2-debian-11-r4" \
      org.opencontainers.image.title="argo-workflow-cli" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="3.5.2"

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/argo-workflows/hack/nsswitch.conf  /etc/nsswitch.conf
COPY --from=builder /opt/bitnami/argo-workflows/bin/argo /argo
COPY --from=builder /opt/bitnami/argo-workflows/hack/ssh_known_hosts /etc/ssh/ssh_known_hosts

ENV APP_VERSION="3.5.2" \
    BITNAMI_APP_NAME="argo-workflow-cli"

USER 1001

ENTRYPOINT [ "/argo" ]
