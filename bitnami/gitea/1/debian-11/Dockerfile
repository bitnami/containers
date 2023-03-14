FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bullseye" \
      org.opencontainers.image.created="2023-03-14T05:11:45Z" \
      org.opencontainers.image.description="Application packaged by VMware, Inc" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="1.18.5-debian-11-r7" \
      org.opencontainers.image.title="gitea" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.18.5"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl git procps
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    COMPONENTS=( \
      "wait-for-port-1.0.6-1-linux-${OS_ARCH}-debian-11" \
      "render-template-1.0.5-1-linux-${OS_ARCH}-debian-11" \
      "ini-file-1.4.5-1-linux-${OS_ARCH}-debian-11" \
      "gosu-1.16.0-2-linux-${OS_ARCH}-debian-11" \
      "gitea-1.18.5-0-linux-${OS_ARCH}-debian-11" \
    ) && \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz.sha256" -O ; \
      fi && \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" && \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done
RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/gitea/postunpack.sh
ENV APP_VERSION="1.18.5" \
    BITNAMI_APP_NAME="gitea" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/gitea/bin:$PATH"

EXPOSE 2222 3000

WORKDIR /opt/bitnami/gitea
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/gitea/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/gitea/run.sh" ]
