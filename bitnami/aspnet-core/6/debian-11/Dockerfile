FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/app" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="6.0.8-debian-11-r6" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/aspnet-core" \
      org.opencontainers.image.title="aspnet-core" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="6.0.8"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl git gzip libc6 libcap2-bin libgcc-s1 libicu-dev liblttng-ust-dev libsqlite3-dev libssl-dev libstdc++6 pkg-config procps tar unzip wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/aspnet-core-6.0.8-1-linux-amd64-debian-11.tar.gz && \
    echo "fe6aabad87fe201bcd524f8185ba727e6352ac7179bc8a161e2ee47204f76cad  /tmp/bitnami/pkg/cache/aspnet-core-6.0.8-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/aspnet-core-6.0.8-1-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/aspnet-core-6.0.8-1-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS    90/' /etc/login.defs && \
    sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS    0/' /etc/login.defs && \
    sed -i 's/sha512/sha512 minlen=8/' /etc/pam.d/common-password

COPY rootfs /
RUN /opt/bitnami/scripts/aspnet-core/postunpack.sh
ENV APP_VERSION="6.0.8" \
    BITNAMI_APP_NAME="aspnet-core" \
    DOTNET_CLI_HOME="/app" \
    DOTNET_ROOT="/opt/bitnami/aspnet-core/bin" \
    PATH="/opt/bitnami/aspnet-core/bin:$PATH"

WORKDIR /app
ENTRYPOINT [ "/opt/bitnami/scripts/aspnet-core/entrypoint.sh" ]
CMD [ "/bin/bash" ]
