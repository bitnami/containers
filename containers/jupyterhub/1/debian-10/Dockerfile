FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libcom-err2 libcurl4 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 librtmp1 libsasl2-2 libssh2-1 libstdc++6 libtasn1-6 libunistring2 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/miniconda-4.11.0-1-linux-amd64-debian-10.tar.gz && \
    echo "3c671cf31696ec6e7971de5ece2257d05a6555d29eac464765fa842e5db705bf  /tmp/bitnami/pkg/cache/miniconda-4.11.0-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/miniconda-4.11.0-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/miniconda-4.11.0-1-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/jupyterhub-1.5.0-8-linux-amd64-debian-10.tar.gz && \
    echo "96210b1d80dd25de39a3845efe0cf962a9ac6ee6277734020c67fb3d3b9dd87d  /tmp/bitnami/pkg/cache/jupyterhub-1.5.0-8-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/jupyterhub-1.5.0-8-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/jupyterhub-1.5.0-8-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="jupyterhub" \
    BITNAMI_IMAGE_VERSION="1.5.0-debian-10-r105" \
    PATH="/opt/bitnami/miniconda/bin:/opt/bitnami/miniconda/bin/:$PATH"

USER 1001
ENTRYPOINT [ "jupyterhub" ]
