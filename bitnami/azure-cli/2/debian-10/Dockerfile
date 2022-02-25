FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libbz2-1.0 libc6 libffi6 libgcc1 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libtinfo6 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-3.7.12-35-linux-amd64-debian-10.tar.gz && \
    echo "bf61bc8137981a153e0d1ca78e38cb9bc493d850992320f97c9694b5693db678  /tmp/bitnami/pkg/cache/python-3.7.12-35-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-3.7.12-35-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-3.7.12-35-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/azure-cli-2.33.1-2-linux-amd64-debian-10.tar.gz && \
    echo "dec7fec0378f590a06e3952e19ce347bd7d8e715ece3eadb2dbfe82ab28beebb  /tmp/bitnami/pkg/cache/azure-cli-2.33.1-2-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/azure-cli-2.33.1-2-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/azure-cli-2.33.1-2-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /.azure /.azcopy && chmod g+rwX /.azure /.azcopy /bin

ENV BITNAMI_APP_NAME="azure-cli" \
    BITNAMI_IMAGE_VERSION="2.33.1-debian-10-r10" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/azure-cli/bin:/opt/bitnami/azure-cli/venv/bin:$PATH"

USER 1001
ENTRYPOINT [ "az" ]
CMD [ "help" ]
