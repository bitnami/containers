FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libbz2-1.0 libc6 libcom-err2 libcrypt1 libffi7 libgcc-s1 libgssapi-krb5-2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblzma5 libncursesw6 libnsl2 libreadline8 libsqlite3-0 libssl1.1 libtinfo6 libtirpc3 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-3.7.13-152-linux-amd64-debian-11.tar.gz && \
    echo "cfa4074f87f8ecb36b5d8d43b2e3cea1887327a0cb7430fb0f0e4e335afa37aa  /tmp/bitnami/pkg/cache/python-3.7.13-152-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-3.7.13-152-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-3.7.13-152-linux-amd64-debian-11.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/azure-cli-2.38.0-0-linux-amd64-debian-11.tar.gz && \
    echo "092d94a02399dcec71389d41473ac4654acbb7a411e4f8c96a57a6eeeba0772c  /tmp/bitnami/pkg/cache/azure-cli-2.38.0-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/azure-cli-2.38.0-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/azure-cli-2.38.0-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /.azure /.azcopy && chmod g+rwX /.azure /.azcopy /bin

ENV APP_VERSION="2.38.0" \
    BITNAMI_APP_NAME="azure-cli" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/azure-cli/bin:/opt/bitnami/azure-cli/venv/bin:$PATH"

USER 1001
ENTRYPOINT [ "az" ]
CMD [ "help" ]
