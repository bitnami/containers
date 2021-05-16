FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/opt/bitnami/jupyterhub-singleuser/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libgcc1 libstdc++6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/miniconda-4.9.2-0-linux-amd64-debian-10.tar.gz && \
    echo "35d4fd9e2c401689d9880a5cd2fb8e099202320a70f025d5f93ca5b800e45d26  /tmp/bitnami/pkg/cache/miniconda-4.9.2-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/miniconda-4.9.2-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/miniconda-4.9.2-0-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/jupyter-base-notebook-1.4.0-1-linux-amd64-debian-10.tar.gz && \
    echo "d76a710f4981e847c7a4608e1c1c55e74bb33b12739f52aaa4a17c742c094cb4  /tmp/bitnami/pkg/cache/jupyter-base-notebook-1.4.0-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/jupyter-base-notebook-1.4.0-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/jupyter-base-notebook-1.4.0-1-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami
RUN mkdir /opt/bitnami/jupyterhub-singleuser/ && chmod g+rwX /opt/bitnami/jupyterhub-singleuser/

ENV BITNAMI_APP_NAME="jupyter-base-notebook" \
    BITNAMI_IMAGE_VERSION="1.4.0-debian-10-r11" \
    PATH="/opt/bitnami/miniconda/bin:$PATH"

USER 1001
ENTRYPOINT [ "tini", "-g", "--" ]
CMD [ "jupyterhub-singlesuser" ]
