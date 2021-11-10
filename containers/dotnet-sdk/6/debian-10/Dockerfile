FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/app" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl git gzip libc6 libcap2-bin libgcc1 libicu-dev liblttng-ust-dev libsqlite3-dev libssl-dev libstdc++6 pkg-config procps tar unzip wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/dotnet-sdk-6.0.100-0-linux-amd64-debian-10.tar.gz && \
    echo "ff0537209e88f6d304bda7d21383e5f8804aa6415eaeb0114ac1901a87f57958  /tmp/bitnami/pkg/cache/dotnet-sdk-6.0.100-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/dotnet-sdk-6.0.100-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/dotnet-sdk-6.0.100-0-linux-amd64-debian-10.tar.gz
RUN sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS    90/' /etc/login.defs && \
    sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS    0/' /etc/login.defs && \
    sed -i 's/sha512/sha512 minlen=8/' /etc/pam.d/common-password

COPY rootfs /
RUN /opt/bitnami/scripts/dotnet-sdk/postunpack.sh
ENV BITNAMI_APP_NAME="dotnet-sdk" \
    BITNAMI_IMAGE_VERSION="6.0.100-debian-10-r1" \
    DOTNET_CLI_HOME="/app" \
    DOTNET_ROOT="/opt/bitnami/dotnet-sdk/bin" \
    PATH="/opt/bitnami/dotnet-sdk/bin:$PATH"

WORKDIR /app
ENTRYPOINT [ "/opt/bitnami/scripts/dotnet-sdk/entrypoint.sh" ]
CMD [ "/bin/bash" ]
