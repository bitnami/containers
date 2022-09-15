FROM docker.io/bitnami/minideb:bullseye

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"
ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.8.345-debian-11-r13" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/java" \
      org.opencontainers.image.title="java" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.8.345"

ENV OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libgcc-s1 libsqlite3-dev libssl-dev locales procps tar wget
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f java-1.8.345-2-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/java-1.8.345-2-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/java-1.8.345-2-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c java-1.8.345-2-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf java-1.8.345-2-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf java-1.8.345-2-linux-${OS_ARCH}-debian-11.tar.gz java-1.8.345-2-linux-${OS_ARCH}-debian-11.tar.gz.sha256
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz.sha256
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8
RUN update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN echo 'en_GB.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS    90/' /etc/login.defs && \
    sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS    0/' /etc/login.defs && \
    sed -i 's/sha512/sha512 minlen=8/' /etc/pam.d/common-password

COPY rootfs /
RUN /opt/bitnami/scripts/locales/add-extra-locales.sh
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV APP_VERSION="1.8.345" \
    BITNAMI_APP_NAME="java" \
    JAVA_HOME="/opt/bitnami/java" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:$PATH"

ENTRYPOINT [ "/opt/bitnami/scripts/java/entrypoint.sh" ]
CMD [ "bash" ]
