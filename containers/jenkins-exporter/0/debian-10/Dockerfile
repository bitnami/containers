FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl libbz2-1.0 libc6 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libtinfo6 procps sudo unzip wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-2.7.17-0-linux-amd64-debian-10.tar.gz && \
    echo "6ff3687780ea65b542a1ce9bcc97a71d5f29c5704c6a177dbd24eb2a9ccaecfe  /tmp/bitnami/pkg/cache/python-2.7.17-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-2.7.17-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-2.7.17-0-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/jenkins-exporter-0.20171225.0-0-linux-amd64-debian-10.tar.gz && \
    echo "9f8a2438b5e786ece9ba6db5aaef40013c3a57f2c6cbc2aefde2e8f5277355cd  /tmp/bitnami/pkg/cache/jenkins-exporter-0.20171225.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/jenkins-exporter-0.20171225.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/jenkins-exporter-0.20171225.0-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

ENV BITNAMI_APP_NAME="jenkins-exporter" \
    BITNAMI_IMAGE_VERSION="0.20171225.0-debian-10-r7" \
    PATH="/opt/bitnami/jenkins-exporter/venv/bin:$PATH"

EXPOSE 9118

WORKDIR /opt/bitnami/jenkins-exporter
USER 1001
ENTRYPOINT [ "python", "-u", "./jenkins_exporter.py" ]
