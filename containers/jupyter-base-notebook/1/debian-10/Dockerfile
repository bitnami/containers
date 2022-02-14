FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/opt/bitnami/jupyterhub-singleuser/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libgcc1 libstdc++6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/miniconda-4.10.3-8-linux-amd64-debian-10.tar.gz && \
    echo "b12c987e9637c0ccb1e0f12977b8423b6456e91921c2d9befa9631a7d4dd88b6  /tmp/bitnami/pkg/cache/miniconda-4.10.3-8-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/miniconda-4.10.3-8-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/miniconda-4.10.3-8-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/jupyter-base-notebook-1.5.0-31-linux-amd64-debian-10.tar.gz && \
    echo "2402aace38c8d5e7a9b90817197aeacbe96f274d8786ee0b4e5f309547b3bbb9  /tmp/bitnami/pkg/cache/jupyter-base-notebook-1.5.0-31-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/jupyter-base-notebook-1.5.0-31-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/jupyter-base-notebook-1.5.0-31-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /opt/bitnami/jupyterhub-singleuser/ && chmod g+rwX /opt/bitnami/jupyterhub-singleuser/

ENV BITNAMI_APP_NAME="jupyter-base-notebook" \
    BITNAMI_IMAGE_VERSION="1.5.0-debian-10-r91" \
    PATH="/opt/bitnami/miniconda/bin:$PATH"

USER 1001
ENTRYPOINT [ "tini", "-g", "--" ]
CMD [ "jupyterhub-singleuser" ]
