FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl git libc6 libcap2-bin libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu-dev libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblttng-ust-dev libnettle6 libnghttp2-14 libp11-kit0 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libunistring2 pkg-config procps sudo unzip wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/dotnet-sdk-3.1.102-0-linux-amd64-debian-10.tar.gz && \
    echo "d491218a8d4cd0a9b821e6867a83603df9a87ec4711c776a744a8a8a1dcf9895  /tmp/bitnami/pkg/cache/dotnet-sdk-3.1.102-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/dotnet-sdk-3.1.102-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/dotnet-sdk-3.1.102-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
RUN /opt/bitnami/scripts/dotnet-sdk/postunpack.sh
ENV BITNAMI_APP_NAME="dotnet-sdk" \
    BITNAMI_IMAGE_VERSION="3.1.102-debian-10-r0" \
    DOTNET_CLI_HOME="/app" \
    HOME="/app" \
    PATH="/opt/bitnami/dotnet-sdk/bin:$PATH"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/dotnet-sdk/entrypoint.sh" ]
CMD [ "/bin/bash" ]
