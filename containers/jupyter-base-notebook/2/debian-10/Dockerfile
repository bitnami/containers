FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/opt/bitnami/jupyterhub-singleuser/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libgcc1 libstdc++6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/miniconda-4.10.3-5-linux-amd64-debian-10.tar.gz && \
    echo "2389592c9632d6934775010ef8233a9955f55dbd70222f8f9124ba95fac7b49a  /tmp/bitnami/pkg/cache/miniconda-4.10.3-5-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/miniconda-4.10.3-5-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/miniconda-4.10.3-5-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/jupyter-base-notebook-2.0.2-3-linux-amd64-debian-10.tar.gz && \
    echo "d87bda8c0d2aca3ccf788b388acdbdacda0f8d1809adeb6a2121bca62eb313db  /tmp/bitnami/pkg/cache/jupyter-base-notebook-2.0.2-3-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/jupyter-base-notebook-2.0.2-3-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/jupyter-base-notebook-2.0.2-3-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /opt/bitnami/jupyterhub-singleuser/ && chmod g+rwX /opt/bitnami/jupyterhub-singleuser/

ENV BITNAMI_APP_NAME="jupyter-base-notebook" \
    BITNAMI_IMAGE_VERSION="2.0.2-debian-10-r8" \
    PATH="/opt/bitnami/miniconda/bin:$PATH"

USER 1001
ENTRYPOINT [ "tini", "-g", "--" ]
CMD [ "jupyterhub-singleuser" ]
