FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libbz2-1.0 libc6 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libtinfo6 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-2.7.18-12-linux-amd64-debian-10.tar.gz && \
    echo "628dbe1685e75f1db52983a894598a9384134b510501a09267fbb14ff070ff68  /tmp/bitnami/pkg/cache/python-2.7.18-12-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-2.7.18-12-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-2.7.18-12-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/jenkins-exporter-0.20171225.0-2-linux-amd64-debian-10.tar.gz && \
    echo "9ff47f0a26c8e3c7846b2ab7e83596758eb7ff92d0824a161a1193ec1d4f47e0  /tmp/bitnami/pkg/cache/jenkins-exporter-0.20171225.0-2-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/jenkins-exporter-0.20171225.0-2-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/jenkins-exporter-0.20171225.0-2-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="jenkins-exporter" \
    BITNAMI_IMAGE_VERSION="0.20171225.0-debian-10-r406" \
    PATH="/opt/bitnami/jenkins-exporter/venv/bin:$PATH"

EXPOSE 9118

WORKDIR /opt/bitnami/jenkins-exporter
USER 1001
ENTRYPOINT [ "python", "-u", "./jenkins_exporter.py" ]
