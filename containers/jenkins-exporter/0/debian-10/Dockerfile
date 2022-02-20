FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libbz2-1.0 libc6 libffi6 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libtinfo6 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-3.8.12-33-linux-amd64-debian-10.tar.gz && \
    echo "0649a1688896cf6ee9a9fd4d554ac33f364f498fca6d8be67a95f8111e7dad4f  /tmp/bitnami/pkg/cache/python-3.8.12-33-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-3.8.12-33-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-3.8.12-33-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/jenkins-exporter-0.20171225.0-10-linux-amd64-debian-10.tar.gz && \
    echo "7444b5e6e517820b41da12ffdd20eb87fc3a6a12b81f81c957ee5f046e2496bb  /tmp/bitnami/pkg/cache/jenkins-exporter-0.20171225.0-10-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/jenkins-exporter-0.20171225.0-10-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/jenkins-exporter-0.20171225.0-10-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="jenkins-exporter" \
    BITNAMI_IMAGE_VERSION="0.20171225.0-debian-10-r711" \
    PATH="/opt/bitnami/jenkins-exporter/venv/bin:$PATH"

EXPOSE 9118

WORKDIR /opt/bitnami/jenkins-exporter
USER 1001
ENTRYPOINT [ "python", "-u", "./jenkins_exporter.py" ]
