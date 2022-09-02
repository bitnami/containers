FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/opt/bitnami/jupyterhub-singleuser/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.3.1-debian-11-r34" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/jupyter-base-notebook" \
      org.opencontainers.image.title="jupyter-base-notebook" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.3.1"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libcrypt1 libgcc-s1 libstdc++6 procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f miniconda-4.12.0-154-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/miniconda-4.12.0-154-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "60138bae1b7541d2ecae75367eaa5ef158f6845dcb86ff746fc8402bdcae716b  miniconda-4.12.0-154-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf miniconda-4.12.0-154-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf miniconda-4.12.0-154-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f jupyter-base-notebook-2.3.1-153-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/jupyter-base-notebook-2.3.1-153-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "40000fbbb169f061f5491fae52ee9945702a52b393adc25657650e135471d675  jupyter-base-notebook-2.3.1-153-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf jupyter-base-notebook-2.3.1-153-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf jupyter-base-notebook-2.3.1-153-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /opt/bitnami/jupyterhub-singleuser/ && chmod g+rwX /opt/bitnami/jupyterhub-singleuser/

ENV APP_VERSION="2.3.1" \
    BITNAMI_APP_NAME="jupyter-base-notebook" \
    PATH="/opt/bitnami/miniconda/bin:$PATH"

USER 1001
ENTRYPOINT [ "tini", "-g", "--" ]
CMD [ "jupyterhub-singleuser" ]
