FROM bitnami/oraclelinux-extras:7-r52 as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/user-broker-0.1.27-0-linux-x86_64-ol-7.tar.gz && \
    echo "d0f549506a970973efa55e3bdb35f9175508096a7144c5d457b3d15804e01802  /tmp/bitnami/pkg/cache/user-broker-0.1.27-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/user-broker-0.1.27-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/user-broker-0.1.27-0-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r52
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/user-broker /opt/bitnami/user-broker
ENV BITNAMI_APP_NAME="user-broker" \
    BITNAMI_IMAGE_VERSION="0.1.27-ol-7-r3" \
    PATH="/opt/bitnami/user-broker/bin:$PATH"

EXPOSE 8005 8080

WORKDIR /opt/bitnami/user-broker
USER 1001
ENTRYPOINT ["/opt/bitnami/user-broker/bin/user-broker"]
