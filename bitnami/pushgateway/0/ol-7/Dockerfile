FROM bitnami/oraclelinux-extras:7-r193 as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/pushgateway-0.7.0-0-linux-x86_64-ol-7.tar.gz && \
    echo "d578e63196582b107a18f8265cf4a2272e4375b12af66d14447a2de1a78c9f75  /tmp/bitnami/pkg/cache/pushgateway-0.7.0-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/pushgateway-0.7.0-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/pushgateway-0.7.0-0-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r193
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/pushgateway /opt/bitnami/pushgateway
ENV BITNAMI_APP_NAME="pushgateway" \
    BITNAMI_IMAGE_VERSION="0.7.0-ol-7-r2" \
    PATH="/opt/bitnami/pushgateway/bin:$PATH"

EXPOSE 9091

WORKDIR /opt/bitnami/pushgateway
USER 1001
ENTRYPOINT [ "/opt/bitnami/pushgateway/bin/pushgateway" ]
