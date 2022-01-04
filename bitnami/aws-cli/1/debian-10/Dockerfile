FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl groff-base gzip libbz2-1.0 libc6 libffi6 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libtinfo6 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-3.7.12-11-linux-amd64-debian-10.tar.gz && \
    echo "3fd33269e9924dfd9ccf7220279a450bab7d76d2df11a1a0d919bde4edcabc03  /tmp/bitnami/pkg/cache/python-3.7.12-11-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-3.7.12-11-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-3.7.12-11-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/aws-cli-1.22.27-0-linux-amd64-debian-10.tar.gz && \
    echo "eda4abef3de54bf55d718194774b54db7db012fe90730171288d47c6a1a26909  /tmp/bitnami/pkg/cache/aws-cli-1.22.27-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/aws-cli-1.22.27-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/aws-cli-1.22.27-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV AWS_CA_BUNDLE="/etc/ssl/certs/ca-certificates.crt" \
    BITNAMI_APP_NAME="aws-cli" \
    BITNAMI_IMAGE_VERSION="1.22.27-debian-10-r0" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/aws-cli/bin:/opt/bitnami/aws-cli/venv/bin:$PATH"

USER 1001
ENTRYPOINT [ "aws" ]
CMD [ "--help" ]
