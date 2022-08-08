FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl groff-base gzip libbz2-1.0 libc6 libcom-err2 libcrypt1 libffi7 libgssapi-krb5-2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblzma5 libncursesw6 libnsl2 libreadline8 libsqlite3-0 libssl1.1 libtinfo6 libtirpc3 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-3.9.13-162-linux-amd64-debian-11.tar.gz && \
    echo "99ef404592f5826b05f2ffb83b77a3480413d25fbd8f1bf7bb6685212769b6a1  /tmp/bitnami/pkg/cache/python-3.9.13-162-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-3.9.13-162-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-3.9.13-162-linux-amd64-debian-11.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/aws-cli-1.25.46-0-linux-amd64-debian-11.tar.gz && \
    echo "b450485df8c5d76d9e1bcbc84ea4157c49f910d7c6b30d2148336f96f1959a6e  /tmp/bitnami/pkg/cache/aws-cli-1.25.46-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/aws-cli-1.25.46-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/aws-cli-1.25.46-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="1.25.46" \
    AWS_CA_BUNDLE="/etc/ssl/certs/ca-certificates.crt" \
    BITNAMI_APP_NAME="aws-cli" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/aws-cli/bin:/opt/bitnami/aws-cli/venv/bin:$PATH"

USER 1001
ENTRYPOINT [ "aws" ]
CMD [ "--help" ]
