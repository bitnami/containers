FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-1.8.161-0-linux-x64-debian-8.tar.gz && \
    echo "eb289afc43eda33d5920294460dc256f6543318506ca5a540bba9073412cfd06  /tmp/bitnami/pkg/cache/java-1.8.161-0-linux-x64-debian-8.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-1.8.161-0-linux-x64-debian-8.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-1.8.161-0-linux-x64-debian-8.tar.gz

ENV BITNAMI_APP_NAME="java" \
    BITNAMI_IMAGE_VERSION="1.8.161-r3" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:$PATH"

CMD ["bash"]
