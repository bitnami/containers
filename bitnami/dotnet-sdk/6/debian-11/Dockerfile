FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="6.0.404-debian-11-r8" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/dotnet-sdk" \
      org.opencontainers.image.title="dotnet-sdk" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="6.0.404"

ENV HOME="/app" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl git libcap2-bin libgcc-s1 libicu-dev liblttng-ust-dev libsqlite3-dev libssl-dev libstdc++6 pkg-config procps unzip wget zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    COMPONENTS=( \
      "dotnet-sdk-6.0.404-0-linux-${OS_ARCH}-debian-11" \
    ) && \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz.sha256" -O ; \
      fi && \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" && \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done
RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS    90/' /etc/login.defs && \
    sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS    0/' /etc/login.defs && \
    sed -i 's/sha512/sha512 minlen=8/' /etc/pam.d/common-password

COPY rootfs /
RUN /opt/bitnami/scripts/dotnet-sdk/postunpack.sh
ENV APP_VERSION="6.0.404" \
    BITNAMI_APP_NAME="dotnet-sdk" \
    DOTNET_CLI_HOME="/app" \
    DOTNET_ROOT="/opt/bitnami/dotnet-sdk/bin" \
    PATH="/opt/bitnami/dotnet-sdk/bin:$PATH"

WORKDIR /app
ENTRYPOINT [ "/opt/bitnami/scripts/dotnet-sdk/entrypoint.sh" ]
CMD [ "/bin/bash" ]
