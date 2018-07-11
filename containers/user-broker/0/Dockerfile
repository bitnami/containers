FROM bitnami/minideb:jessie as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/user-broker-0.1.23-0-linux-x64-debian-8.tar.gz && \
    echo "41a8eb18b95448b7fe1f527aa26ac19dbbbc3d0e211b92c7d855cec5bf721720  /tmp/bitnami/pkg/cache/user-broker-0.1.23-0-linux-x64-debian-8.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/user-broker-0.1.23-0-linux-x64-debian-8.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/user-broker-0.1.23-0-linux-x64-debian-8.tar.gz

##################

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/user-broker /opt/bitnami/user-broker
ENV BITNAMI_APP_NAME="user-broker" \
    BITNAMI_IMAGE_VERSION="0.1.23-debian-8-r10" \
    PATH="/opt/bitnami/user-broker/bin:$PATH"

EXPOSE 8005 8080

WORKDIR /opt/bitnami/user-broker
USER 1001
ENTRYPOINT ["/opt/bitnami/user-broker/bin/user-broker"]
