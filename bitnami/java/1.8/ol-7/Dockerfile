FROM bitnami/oraclelinux-runtimes:7-r441
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates glibc libgcc wget zlib
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-1.8.222-0-linux-x86_64-ol-7.tar.gz && \
    echo "a90f4ce71ff9b392efdf61e6941117afa31d2d6528bd1a3cad1c6459bcac2b0b  /tmp/bitnami/pkg/cache/java-1.8.222-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-1.8.222-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-1.8.222-0-linux-x86_64-ol-7.tar.gz

ENV BITNAMI_APP_NAME="java" \
    BITNAMI_IMAGE_VERSION="1.8.222-ol-7-r61" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:$PATH"

CMD [ "bash" ]
