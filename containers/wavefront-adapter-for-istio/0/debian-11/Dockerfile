FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/wavefront-adapter-for-istio-0.1.5-0-linux-amd64-debian-11.tar.gz && \
    echo "cec34ae877091421277c1d43bd2bef9db8eeae2915f1188f9c266145c67de65d  /tmp/bitnami/pkg/cache/wavefront-adapter-for-istio-0.1.5-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/wavefront-adapter-for-istio-0.1.5-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/wavefront-adapter-for-istio-0.1.5-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="0.1.5" \
    BITNAMI_APP_NAME="wavefront-adapter-for-istio" \
    PATH="/opt/bitnami/wavefront-adapter-for-istio/bin:$PATH"

EXPOSE 37671

USER 1001
ENTRYPOINT [ "wavefront" ]
