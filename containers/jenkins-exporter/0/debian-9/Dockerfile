FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl libbz2-1.0 libc6 libncurses5 libreadline7 libsqlite3-0 libssl1.1 libtinfo5 procps unzip wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-2.7.17-1-linux-amd64-debian-9.tar.gz && \
    echo "27dd8b9191d766d555257113720c176fa13ba38c64000c373d14924eac7dc070  /tmp/bitnami/pkg/cache/python-2.7.17-1-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-2.7.17-1-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-2.7.17-1-linux-amd64-debian-9.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/jenkins-exporter-0.20171225.0-1-linux-amd64-debian-9.tar.gz && \
    echo "a77c1c504068df9b599eb02139bfb7359f8ece9db1d9f1f80e7d9e8c704458f4  /tmp/bitnami/pkg/cache/jenkins-exporter-0.20171225.0-1-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/jenkins-exporter-0.20171225.0-1-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/jenkins-exporter-0.20171225.0-1-linux-amd64-debian-9.tar.gz
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

ENV BITNAMI_APP_NAME="jenkins-exporter" \
    BITNAMI_IMAGE_VERSION="0.20171225.0-debian-9-r136" \
    PATH="/opt/bitnami/jenkins-exporter/venv/bin:$PATH"

EXPOSE 9118

WORKDIR /opt/bitnami/jenkins-exporter
USER 1001
ENTRYPOINT [ "python", "-u", "./jenkins_exporter.py" ]
