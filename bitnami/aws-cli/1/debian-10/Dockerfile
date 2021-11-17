FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl groff-base gzip libbz2-1.0 libc6 libffi6 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libtinfo6 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-3.7.12-5-linux-amd64-debian-10.tar.gz && \
    echo "3a43049bde8f33c72c7d56b94416df67ab7ab129944c624d60b2d59b9e602854  /tmp/bitnami/pkg/cache/python-3.7.12-5-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-3.7.12-5-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-3.7.12-5-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/aws-cli-1.22.8-0-linux-amd64-debian-10.tar.gz && \
    echo "c3157479eb6b359d415463e56910abdf434668e7dc14e611a741e25f31daf1af  /tmp/bitnami/pkg/cache/aws-cli-1.22.8-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/aws-cli-1.22.8-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/aws-cli-1.22.8-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV AWS_CA_BUNDLE="/etc/ssl/certs/ca-certificates.crt" \
    BITNAMI_APP_NAME="aws-cli" \
    BITNAMI_IMAGE_VERSION="1.22.8-debian-10-r0" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/aws-cli/bin:/opt/bitnami/aws-cli/venv/bin:$PATH"

USER 1001
ENTRYPOINT [ "aws" ]
CMD [ "--help" ]
