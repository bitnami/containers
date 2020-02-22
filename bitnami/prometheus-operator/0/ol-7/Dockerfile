FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip hostname libaio-devel procps-ng sudo tar wget which
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/prometheus-operator-0.36.0-0-linux-x86_64-ol-7.tar.gz && \
    echo "1d187d57cbfc85c4d2736f8a7b3c9cf0601ca10f0d2229288592e7ba36e32f17  /tmp/bitnami/pkg/cache/prometheus-operator-0.36.0-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/prometheus-operator-0.36.0-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/prometheus-operator-0.36.0-0-linux-x86_64-ol-7.tar.gz
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN ln -sf /opt/bitnami/prometheus-operator/bin/operator /bin/operator
RUN ln -sf /opt/bitnami/prometheus-operator/bin/prometheus-config-reloader /bin/prometheus-config-reloader

ENV BITNAMI_APP_NAME="prometheus-operator" \
    BITNAMI_IMAGE_VERSION="0.36.0-ol-7-r11" \
    PATH="/opt/bitnami/prometheus-operator/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/prometheus-operator
USER 1001
ENTRYPOINT [ "/bin/operator" ]
