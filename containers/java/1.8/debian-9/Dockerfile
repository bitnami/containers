FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates libc6 libgcc1 libsqlite3-dev libssl-dev libssl1.0.2 wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-1.8.222-1-linux-amd64-debian-9.tar.gz && \
    echo "373c9f3d2943b9ff653fc0e7c69b1d54a75807726691a09190648808500b8253  /tmp/bitnami/pkg/cache/java-1.8.222-1-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-1.8.222-1-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-1.8.222-1-linux-amd64-debian-9.tar.gz
RUN sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS    90/' /etc/login.defs && \
    sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS    0/' /etc/login.defs && \
    sed -i 's/sha512/sha512 minlen=8/' /etc/pam.d/common-password

ENV BITNAMI_APP_NAME="java" \
    BITNAMI_IMAGE_VERSION="1.8.222-debian-9-r67" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:$PATH"

CMD [ "bash" ]
