FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/opt/bitnami/jupyterhub-singleuser/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libgcc1 libstdc++6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/miniconda-4.11.0-1-linux-amd64-debian-10.tar.gz && \
    echo "3c671cf31696ec6e7971de5ece2257d05a6555d29eac464765fa842e5db705bf  /tmp/bitnami/pkg/cache/miniconda-4.11.0-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/miniconda-4.11.0-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/miniconda-4.11.0-1-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/jupyter-base-notebook-1.5.0-33-linux-amd64-debian-10.tar.gz && \
    echo "9c0e01776017ce072bc16eea8e5f7b46f1c6ce62ac1654b98f30dcb6d7b13b9e  /tmp/bitnami/pkg/cache/jupyter-base-notebook-1.5.0-33-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/jupyter-base-notebook-1.5.0-33-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/jupyter-base-notebook-1.5.0-33-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /opt/bitnami/jupyterhub-singleuser/ && chmod g+rwX /opt/bitnami/jupyterhub-singleuser/

ENV BITNAMI_APP_NAME="jupyter-base-notebook" \
    BITNAMI_IMAGE_VERSION="1.5.0-debian-10-r98" \
    PATH="/opt/bitnami/miniconda/bin:$PATH"

USER 1001
ENTRYPOINT [ "tini", "-g", "--" ]
CMD [ "jupyterhub-singleuser" ]
