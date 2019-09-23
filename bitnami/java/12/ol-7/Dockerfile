FROM bitnami/oraclelinux-runtimes:7-r446
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates glibc wget zlib
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-12.0.2-1-linux-x86_64-ol-7.tar.gz && \
    echo "9098298a1e2a2dffadf80ba64daf203950f3f33808043e73d6035a429bcdccff  /tmp/bitnami/pkg/cache/java-12.0.2-1-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-12.0.2-1-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-12.0.2-1-linux-x86_64-ol-7.tar.gz

ENV BITNAMI_APP_NAME="java" \
    BITNAMI_IMAGE_VERSION="12.0.2-ol-7-r13" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:$PATH"

CMD [ "bash" ]
