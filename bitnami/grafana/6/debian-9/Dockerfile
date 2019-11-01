FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl libblkid1 libc6 libexpat1 libffi6 libfontconfig libgcc1 libglib2.0-0 libmount1 libpcre3 libselinux1 libstdc++6 libuuid1 wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/grafana-6.4.3-0-linux-amd64-debian-9.tar.gz && \
    echo "5c83ffda5e41227ec574b0f316cfb58c406306d33d30fbd067a35b3ae51d0a51  /tmp/bitnami/pkg/cache/grafana-6.4.3-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/grafana-6.4.3-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/grafana-6.4.3-0-linux-amd64-debian-9.tar.gz
RUN mv /opt/bitnami/grafana/conf/sample.ini /opt/bitnami/grafana/conf/grafana.ini
RUN mkdir -p /opt/bitnami/grafana/data/ /opt/bitnami/grafana/logs/ && chmod g+rwX /opt/bitnami/grafana/data/ /opt/bitnami/grafana/logs/

COPY rootfs /
ENV BITNAMI_APP_NAME="grafana" \
    BITNAMI_IMAGE_VERSION="6.4.3-debian-9-r11" \
    PATH="/opt/bitnami/grafana/bin:$PATH"

EXPOSE 3000

WORKDIR /opt/bitnami/grafana
USER 1001
ENTRYPOINT [ "/run.sh" ]
