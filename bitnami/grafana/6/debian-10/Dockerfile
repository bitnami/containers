FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl libblkid1 libc6 libexpat1 libffi6 libfontconfig libgcc1 libglib2.0-0 libmount1 libpcre3 libselinux1 libstdc++6 libuuid1 procps sudo unzip wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/grafana-6.7.2-0-linux-amd64-debian-10.tar.gz && \
    echo "9feaeef933bed94c72f6e2e73072f4e579f326075ccfd1c07d4cea1abf48cf0e  /tmp/bitnami/pkg/cache/grafana-6.7.2-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/grafana-6.7.2-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/grafana-6.7.2-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN mv /opt/bitnami/grafana/conf/sample.ini /opt/bitnami/grafana/conf/grafana.ini
RUN mkdir -p /opt/bitnami/grafana/data/ /opt/bitnami/grafana/logs/ && chmod g+rwX /opt/bitnami/grafana/data/ /opt/bitnami/grafana/logs/

COPY rootfs /
RUN /grafana-plugins.sh
ENV BITNAMI_APP_NAME="grafana" \
    BITNAMI_IMAGE_VERSION="6.7.2-debian-10-r11" \
    PATH="/opt/bitnami/grafana/bin:$PATH"

EXPOSE 3000

WORKDIR /opt/bitnami/grafana
USER 1001
ENTRYPOINT [ "/run.sh" ]
