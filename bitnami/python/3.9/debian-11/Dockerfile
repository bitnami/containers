FROM docker.io/bitnami/minideb:bullseye
ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="3.9.13-debian-11-r41" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/python" \
      org.opencontainers.image.title="python" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="3.9.13"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl git gzip libbz2-1.0 libc6 libcom-err2 libcrypt1 libffi7 libgssapi-krb5-2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblzma5 libncursesw6 libnsl2 libreadline8 libsqlite3-0 libsqlite3-dev libssl-dev libssl1.1 libtinfo6 libtirpc3 pkg-config procps tar unzip wget zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f python-3.9.13-166-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/python-3.9.13-166-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "44a685c2a95a8a70f982f32154027bf83ec58cd19f362f48ccb760efb464bfe5  python-3.9.13-166-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf python-3.9.13-166-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf python-3.9.13-166-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS    90/' /etc/login.defs && \
    sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS    0/' /etc/login.defs && \
    sed -i 's/sha512/sha512 minlen=8/' /etc/pam.d/common-password

ENV APP_VERSION="3.9.13" \
    BITNAMI_APP_NAME="python" \
    PATH="/opt/bitnami/python/bin:$PATH"

EXPOSE 8000

WORKDIR /app
CMD [ "python" ]
