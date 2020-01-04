FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates libc6 libsqlite3-dev libssl-dev libssl1.0.2 wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-11.0.5-0-linux-amd64-debian-9.tar.gz && \
    echo "9fc7502ca3c073e6ae7dd6cfa0c2da6b6c26caccbe41b6d7b5a9d26050ee54ff  /tmp/bitnami/pkg/cache/java-11.0.5-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-11.0.5-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-11.0.5-0-linux-amd64-debian-9.tar.gz
RUN sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS    90/' /etc/login.defs && \
    sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS    0/' /etc/login.defs && \
    sed -i 's/sha512/sha512 minlen=8/' /etc/pam.d/common-password

ENV BITNAMI_APP_NAME="java" \
    BITNAMI_IMAGE_VERSION="11.0.5-debian-9-r63" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:$PATH"

CMD [ "bash" ]
