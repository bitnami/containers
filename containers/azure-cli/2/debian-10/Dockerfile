FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libbz2-1.0 libc6 libffi6 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libtinfo6 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-3.7.9-4-linux-amd64-debian-10.tar.gz && \
    echo "82d20f1026313f6aa644f442e603fdebcfe2176ed23cefca832d131740ccac26  /tmp/bitnami/pkg/cache/python-3.7.9-4-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-3.7.9-4-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-3.7.9-4-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/azure-cli-2.13.0-0-linux-amd64-debian-10.tar.gz && \
    echo "46e24f60aa7ef18f708ce0293229328d745561df263239188a39df9725241145  /tmp/bitnami/pkg/cache/azure-cli-2.13.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/azure-cli-2.13.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/azure-cli-2.13.0-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /.azure /.azcopy && chmod g+rwX /.azure /.azcopy /bin

ENV BITNAMI_APP_NAME="azure-cli" \
    BITNAMI_IMAGE_VERSION="2.13.0-debian-10-r0" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/azure-cli/bin:/opt/bitnami/azure-cli/venv/bin:$PATH"

USER 1001
ENTRYPOINT [ "az" ]
CMD [ "help" ]
