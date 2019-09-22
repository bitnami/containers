FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates libc6 libsqlite3-dev libssl-dev libssl1.0.2 wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-11.0.4-1-linux-amd64-debian-9.tar.gz && \
    echo "561cd1095eaca816109f92dcb5f68a53b788cfa6734782763350b980a4e5538a  /tmp/bitnami/pkg/cache/java-11.0.4-1-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-11.0.4-1-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-11.0.4-1-linux-amd64-debian-9.tar.gz
RUN sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS    90/' /etc/login.defs && \
    sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS    0/' /etc/login.defs && \
    sed -i 's/sha512/sha512 minlen=8/' /etc/pam.d/common-password

ENV BITNAMI_APP_NAME="java" \
    BITNAMI_IMAGE_VERSION="11.0.4-debian-9-r62" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:$PATH"

CMD [ "bash" ]
