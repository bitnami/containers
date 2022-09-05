FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"
LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="8.9.9-debian-11-r24" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/sonarqube" \
      org.opencontainers.image.title="sonarqube" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="8.9.9"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbsd0 libc6 libedit2 libffi7 libgcc-s1 libgmp10 libgnutls30 libhogweed6 libicu67 libidn2-0 libldap-2.4-2 liblzma5 libmd0 libnettle8 libp11-kit0 libsasl2-2 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxslt1.1 procps tar zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f postgresql-client-13.8.0-1-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/postgresql-client-13.8.0-1-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "ed27577fe07511a7ff3ba58800604c463387cdd21fb3f64473e75f327b73565d  postgresql-client-13.8.0-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf postgresql-client-13.8.0-1-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf postgresql-client-13.8.0-1-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f java-11.0.15-1-3-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/java-11.0.15-1-3-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "7214b8ab81c9d919f87f027590ca80c198f65fe50c5e2886d8e5e20691aee8d7  java-11.0.15-1-3-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf java-11.0.15-1-3-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf java-11.0.15-1-3-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f sonarqube-8.9.9-7-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/sonarqube-8.9.9-7-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "88f115ffe66e28634e98139091dcd3fe24bfaf67c8c71a2c16d7f5cfb83378f4  sonarqube-8.9.9-7-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf sonarqube-8.9.9-7-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf sonarqube-8.9.9-7-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f gosu-1.14.0-154-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/gosu-1.14.0-154-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab  gosu-1.14.0-154-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf gosu-1.14.0-154-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf gosu-1.14.0-154-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/sonarqube/postunpack.sh
ENV APP_VERSION="8.9.9" \
    BITNAMI_APP_NAME="sonarqube" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/postgresql/bin:/opt/bitnami/java/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 9000

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/sonarqube/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/sonarqube/run.sh" ]
