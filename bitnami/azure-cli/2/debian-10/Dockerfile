FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl libbz2-1.0 libc6 libffi6 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libtinfo6 procps sudo unzip wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-3.7.7-1-linux-amd64-debian-10.tar.gz && \
    echo "bcaa343f19e4c8d5da822a91626a166c933f010d5373c4faa0261fcff0d79f28  /tmp/bitnami/pkg/cache/python-3.7.7-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-3.7.7-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-3.7.7-1-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/azure-cli-2.4.0-0-linux-amd64-debian-10.tar.gz && \
    echo "431a8760ed171a499ae20c433a646e06f933e52b2d4b80e00e33cf4f1341f8f1  /tmp/bitnami/pkg/cache/azure-cli-2.4.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/azure-cli-2.4.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/azure-cli-2.4.0-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN mkdir /.azure /.azcopy && chmod g+rwX /.azure /.azcopy /bin

ENV BITNAMI_APP_NAME="azure-cli" \
    BITNAMI_IMAGE_VERSION="2.4.0-debian-10-r7" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/azure-cli/bin:/opt/bitnami/azure-cli/venv/bin:$PATH"

USER 1001
ENTRYPOINT [ "az" ]
CMD [ "help" ]
