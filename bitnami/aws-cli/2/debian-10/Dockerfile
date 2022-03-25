FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl groff-base gzip libbz2-1.0 libc6 libffi6 libgcc1 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libtinfo6 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-3.9.12-0-linux-amd64-debian-10.tar.gz && \
    echo "13decc0aa3d005eeb19d8c152898c586fa54b04adbdb60b9f79dd439a5494ad2  /tmp/bitnami/pkg/cache/python-3.9.12-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-3.9.12-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-3.9.12-0-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/aws-cli-2.4.28-0-linux-amd64-debian-10.tar.gz && \
    echo "07071dce33375ac71da4ea0d9a1be3862304ff011eb809e1994cd69c1305bb2d  /tmp/bitnami/pkg/cache/aws-cli-2.4.28-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/aws-cli-2.4.28-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/aws-cli-2.4.28-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="2.4.28" \
    AWS_CA_BUNDLE="/etc/ssl/certs/ca-certificates.crt" \
    BITNAMI_APP_NAME="aws-cli" \
    BITNAMI_IMAGE_VERSION="2.4.28-debian-10-r0" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/aws-cli/bin:/opt/bitnami/aws-cli/venv/bin:$PATH"

USER 1001
ENTRYPOINT [ "aws" ]
CMD [ "--help" ]
