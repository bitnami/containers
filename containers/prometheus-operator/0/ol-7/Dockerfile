FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip hostname libaio-devel procps-ng sudo tar wget which
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/prometheus-operator-0.35.0-0-linux-x86_64-ol-7.tar.gz && \
    echo "b81dbab8997f3a3c37a2fc7ce3accf987f3fdb30d8c546c7375ed99c4ff14848  /tmp/bitnami/pkg/cache/prometheus-operator-0.35.0-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/prometheus-operator-0.35.0-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/prometheus-operator-0.35.0-0-linux-x86_64-ol-7.tar.gz
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN ln -sf /opt/bitnami/prometheus-operator/bin/operator /bin/operator
RUN ln -sf /opt/bitnami/prometheus-operator/bin/prometheus-config-reloader /bin/prometheus-config-reloader

ENV BITNAMI_APP_NAME="prometheus-operator" \
    BITNAMI_IMAGE_VERSION="0.35.0-ol-7-r16" \
    PATH="/opt/bitnami/prometheus-operator/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/prometheus-operator
USER 1001
ENTRYPOINT [ "/bin/operator" ]
