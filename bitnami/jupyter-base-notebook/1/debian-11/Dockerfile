FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.5.0-debian-11-r39" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/jupyter-base-notebook" \
      org.opencontainers.image.title="jupyter-base-notebook" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.5.0"

ENV HOME="/opt/bitnami/jupyterhub-singleuser/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libcrypt1 libgcc-s1 libstdc++6 procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f miniconda-4.12.0-154-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/miniconda-4.12.0-154-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/miniconda-4.12.0-154-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c miniconda-4.12.0-154-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf miniconda-4.12.0-154-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf miniconda-4.12.0-154-linux-${OS_ARCH}-debian-11.tar.gz miniconda-4.12.0-154-linux-${OS_ARCH}-debian-11.tar.gz.sha256
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f jupyter-base-notebook-1.5.0-153-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/jupyter-base-notebook-1.5.0-153-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/jupyter-base-notebook-1.5.0-153-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c jupyter-base-notebook-1.5.0-153-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf jupyter-base-notebook-1.5.0-153-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf jupyter-base-notebook-1.5.0-153-linux-${OS_ARCH}-debian-11.tar.gz jupyter-base-notebook-1.5.0-153-linux-${OS_ARCH}-debian-11.tar.gz.sha256
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /opt/bitnami/jupyterhub-singleuser/ && chmod g+rwX /opt/bitnami/jupyterhub-singleuser/

ENV APP_VERSION="1.5.0" \
    BITNAMI_APP_NAME="jupyter-base-notebook" \
    PATH="/opt/bitnami/miniconda/bin:$PATH"

USER 1001
ENTRYPOINT [ "tini", "-g", "--" ]
CMD [ "jupyterhub-singleuser" ]
