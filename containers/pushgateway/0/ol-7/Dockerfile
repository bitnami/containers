FROM bitnami/oraclelinux-extras:7-r141 as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/pushgateway-0.5.2-1-linux-x86_64-ol-7.tar.gz && \
    echo "2294f558de2af2e6b987832c68bca3dc19fab418b9c5e2a401f9cbdbacf3e6bf  /tmp/bitnami/pkg/cache/pushgateway-0.5.2-1-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/pushgateway-0.5.2-1-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/pushgateway-0.5.2-1-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r141
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/pushgateway /opt/bitnami/pushgateway
ENV BITNAMI_APP_NAME="pushgateway" \
    BITNAMI_IMAGE_VERSION="0.5.2-ol-7-r101" \
    PATH="/opt/bitnami/pushgateway/bin:$PATH"

EXPOSE 9091

WORKDIR /opt/bitnami/pushgateway
USER 1001
ENTRYPOINT [ "/opt/bitnami/pushgateway/bin/pushgateway" ]
