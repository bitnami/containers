FROM bitnami/oraclelinux-extras:7-r53 as buildenv

RUN install_packages ca-certificates glibc wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubewatch-0.0.4-0-linux-x86_64-ol-7.tar.gz && \
    echo "8b7d60edba7c49f1750d35d3cb1869494cfd5665bfe32b127efe1ea7c7dbde32  /tmp/bitnami/pkg/cache/kubewatch-0.0.4-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubewatch-0.0.4-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubewatch-0.0.4-0-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r53
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/kubewatch /opt/bitnami/kubewatch
ENV BITNAMI_APP_NAME="kubewatch" \
    BITNAMI_IMAGE_VERSION="0.0.4-ol-7-r36" \
    HOME="/opt/bitnami/kubewatch/" \
    KW_FLOCK_URL="" \
    KW_HIPCHAT_ROOM="" \
    KW_HIPCHAT_TOKEN="" \
    KW_HIPCHAT_URL="" \
    KW_MATTERMOST_CHANNEL="" \
    KW_MATTERMOST_URL="" \
    KW_MATTERMOST_USERNAME="" \
    KW_SLACK_CHANNEL="" \
    KW_SLACK_TOKEN="" \
    KW_WEBHOOK_URL="" \
    PATH="/opt/bitnami/kubewatch/bin:$PATH"

RUN install_packages ca-certificates
RUN chmod g+rwX /opt/bitnami/kubewatch/

COPY rootfs /
WORKDIR /opt/bitnami/kubewatch
USER 1001
ENTRYPOINT ["/entrypoint.sh"]
