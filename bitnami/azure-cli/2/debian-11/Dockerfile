FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.40.0-debian-11-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/azure-cli" \
      org.opencontainers.image.title="azure-cli" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.40.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libbz2-1.0 libc6 libcom-err2 libcrypt1 libffi7 libgcc-s1 libgssapi-krb5-2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblzma5 libncursesw6 libnsl2 libreadline8 libsqlite3-0 libssl1.1 libtinfo6 libtirpc3 procps tar zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f python-3.7.13-167-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/python-3.7.13-167-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "39b3ee57881cc28df099e5c7d2ab7e945b259ab0821be1961a522df6b70c2832  python-3.7.13-167-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf python-3.7.13-167-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf python-3.7.13-167-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f azure-cli-2.40.0-0-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/azure-cli-2.40.0-0-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "1293a63ca7c710fef9853c488070d2caab55a1c12adeeedd1568411dc6c0898c  azure-cli-2.40.0-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf azure-cli-2.40.0-0-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf azure-cli-2.40.0-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /.azure /.azcopy && chmod g+rwX /.azure /.azcopy /bin

ENV APP_VERSION="2.40.0" \
    BITNAMI_APP_NAME="azure-cli" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/azure-cli/bin:/opt/bitnami/azure-cli/venv/bin:$PATH"

USER 1001
ENTRYPOINT [ "az" ]
CMD [ "help" ]
