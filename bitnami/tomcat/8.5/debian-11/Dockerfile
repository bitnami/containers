FROM docker.io/bitnami/minideb:bullseye

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"
ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="8.5.82-debian-11-r13" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/tomcat" \
      org.opencontainers.image.title="tomcat" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="8.5.82"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libssl1.1 procps tar xmlstarlet zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f java-11.0.15-1-3-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/java-11.0.15-1-3-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/java-11.0.15-1-3-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c java-11.0.15-1-3-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf java-11.0.15-1-3-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf java-11.0.15-1-3-linux-${OS_ARCH}-debian-11.tar.gz java-11.0.15-1-3-linux-${OS_ARCH}-debian-11.tar.gz.sha256
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f tomcat-8.5.82-3-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/tomcat-8.5.82-3-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/tomcat-8.5.82-3-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c tomcat-8.5.82-3-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf tomcat-8.5.82-3-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf tomcat-8.5.82-3-linux-${OS_ARCH}-debian-11.tar.gz tomcat-8.5.82-3-linux-${OS_ARCH}-debian-11.tar.gz.sha256
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f render-template-1.0.3-153-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/render-template-1.0.3-153-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/render-template-1.0.3-153-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c render-template-1.0.3-153-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf render-template-1.0.3-153-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf render-template-1.0.3-153-linux-${OS_ARCH}-debian-11.tar.gz render-template-1.0.3-153-linux-${OS_ARCH}-debian-11.tar.gz.sha256
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
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/tomcat/postunpack.sh
ENV APP_VERSION="8.5.82" \
    BITNAMI_APP_NAME="tomcat" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8009 8080

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/tomcat/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/tomcat/run.sh" ]
