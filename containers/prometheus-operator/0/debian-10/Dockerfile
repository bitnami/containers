FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps sudo unzip wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/prometheus-operator-0.37.0-0-linux-amd64-debian-10.tar.gz && \
    echo "d457b21396e5dc829cbe9ae96e8ba71b213fdc2432fac15b93b1f687323d8f02  /tmp/bitnami/pkg/cache/prometheus-operator-0.37.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/prometheus-operator-0.37.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/prometheus-operator-0.37.0-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN ln -sf /opt/bitnami/prometheus-operator/bin/operator /bin/operator
RUN ln -sf /opt/bitnami/prometheus-operator/bin/prometheus-config-reloader /bin/prometheus-config-reloader

ENV BITNAMI_APP_NAME="prometheus-operator" \
    BITNAMI_IMAGE_VERSION="0.37.0-debian-10-r0" \
    PATH="/opt/bitnami/prometheus-operator/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/prometheus-operator
USER 1001
ENTRYPOINT [ "/bin/operator" ]
