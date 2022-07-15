FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/opt/bitnami/jupyterhub-singleuser/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libcrypt1 libgcc-s1 libstdc++6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/miniconda-4.12.0-152-linux-amd64-debian-11.tar.gz && \
    echo "54562193edb2be58d871e34d0c8238c7f4edc59d30950bd256fbf42103941afa  /tmp/bitnami/pkg/cache/miniconda-4.12.0-152-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/miniconda-4.12.0-152-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/miniconda-4.12.0-152-linux-amd64-debian-11.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/jupyter-base-notebook-1.5.0-151-linux-amd64-debian-11.tar.gz && \
    echo "491f5c54b8afb1ebdddfba0a34647a91ce32f913504fed06047ab3438a3711b1  /tmp/bitnami/pkg/cache/jupyter-base-notebook-1.5.0-151-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/jupyter-base-notebook-1.5.0-151-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/jupyter-base-notebook-1.5.0-151-linux-amd64-debian-11.tar.gz
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
