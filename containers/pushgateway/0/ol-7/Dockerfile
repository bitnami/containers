FROM bitnami/oraclelinux-extras:7-r156 as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/pushgateway-0.6.0-0-linux-x86_64-ol-7.tar.gz && \
    echo "ecc6bb02b2ec02e8c4850e20e3a6d06e35604a9ba5250f4c82a5fef7f6268ed2  /tmp/bitnami/pkg/cache/pushgateway-0.6.0-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/pushgateway-0.6.0-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/pushgateway-0.6.0-0-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r156
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/pushgateway /opt/bitnami/pushgateway
ENV BITNAMI_APP_NAME="pushgateway" \
    BITNAMI_IMAGE_VERSION="0.6.0-ol-7-r15" \
    PATH="/opt/bitnami/pushgateway/bin:$PATH"

EXPOSE 9091

WORKDIR /opt/bitnami/pushgateway
USER 1001
ENTRYPOINT [ "/opt/bitnami/pushgateway/bin/pushgateway" ]
