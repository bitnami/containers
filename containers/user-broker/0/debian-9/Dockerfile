FROM bitnami/minideb:stretch as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/user-broker-0.1.34-0-linux-amd64-debian-9.tar.gz && \
    echo "794024d0fe0c2c9b392f48b74ec68341e4259077a91efb80027c5ef8f340748c  /tmp/bitnami/pkg/cache/user-broker-0.1.34-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/user-broker-0.1.34-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/user-broker-0.1.34-0-linux-amd64-debian-9.tar.gz

##################

FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/user-broker /opt/bitnami/user-broker
ENV BITNAMI_APP_NAME="user-broker" \
    BITNAMI_IMAGE_VERSION="0.1.34-debian-9-r3" \
    PATH="/opt/bitnami/user-broker/bin:$PATH"

EXPOSE 8005 8080

WORKDIR /opt/bitnami/user-broker
USER 1001
ENTRYPOINT [ "/opt/bitnami/user-broker/bin/user-broker" ]
