FROM bitnami/oraclelinux-extras:7-r501
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/prometheus-operator-0.33.0-0-linux-x86_64-ol-7.tar.gz && \
    echo "1455f6ada763747f721f4c6d3e23cc6eca409777c2766d1b278e8dc02bf58115  /tmp/bitnami/pkg/cache/prometheus-operator-0.33.0-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/prometheus-operator-0.33.0-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/prometheus-operator-0.33.0-0-linux-x86_64-ol-7.tar.gz
RUN ln -sf /opt/bitnami/prometheus-operator/bin/operator /bin/operator
RUN ln -sf /opt/bitnami/prometheus-operator/bin/prometheus-config-reloader /bin/prometheus-config-reloader

ENV BITNAMI_APP_NAME="prometheus-operator" \
    BITNAMI_IMAGE_VERSION="0.33.0-ol-7-r1" \
    PATH="/opt/bitnami/prometheus-operator/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/prometheus-operator
USER 1001
ENTRYPOINT [ "/bin/operator" ]
