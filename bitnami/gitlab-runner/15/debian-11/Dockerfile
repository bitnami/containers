FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="15.3.0-debian-11-r3" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/gitlab-runner" \
      org.opencontainers.image.title="gitlab-runner" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="15.3.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl git git-lfs gzip libc6 openssh-client procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f dumb-init-1.2.5-153-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/dumb-init-1.2.5-153-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "40f42ee4af6e04192a41f4e099403b16aa92fc1a047249e6d63715d92b77c672  dumb-init-1.2.5-153-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf dumb-init-1.2.5-153-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf dumb-init-1.2.5-153-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f docker-machine-0.16.2-153-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/docker-machine-0.16.2-153-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "12aa80f8959086bd1ad68104a12e2490b66bee26949a4050d612e3d41e63058d  docker-machine-0.16.2-153-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf docker-machine-0.16.2-153-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf docker-machine-0.16.2-153-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f gosu-1.14.0-154-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/gosu-1.14.0-154-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab  gosu-1.14.0-154-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf gosu-1.14.0-154-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf gosu-1.14.0-154-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f gitlab-runner-15.3.0-1-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/gitlab-runner-15.3.0-1-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "ba763f836ef0296c4ff17179f8065c6665d6033884f2df2b744d2b2ee04f6fd6  gitlab-runner-15.3.0-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf gitlab-runner-15.3.0-1-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf gitlab-runner-15.3.0-1-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN mkdir /home/gitlab-runner && chmod -R g+rwX /home/gitlab-runner && ln -s /opt/bitnami/common/bin/dumb-init /usr/bin/dumb-init && ln -s /opt/bitnami/scripts/gitlab-runner/entrypoint.sh /entrypoint
ENV APP_VERSION="15.3.0" \
    BITNAMI_APP_NAME="gitlab-runner" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/gitlab-runner/bin:$PATH"

USER 1001
ENTRYPOINT [ "/usr/bin/dumb-init", "/opt/bitnami/scripts/gitlab-runner/entrypoint.sh" ]
CMD [ "run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner" ]
