FROM bitnami/minideb:stretch as buildenv

RUN install_packages ca-certificates libc6 wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubewatch-0.0.4-20-linux-amd64-debian-9.tar.gz && \
    echo "b049e7c93f55e344272f044593a2372a5137652160b571ee6ab5a3554270ce3f  /tmp/bitnami/pkg/cache/kubewatch-0.0.4-20-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubewatch-0.0.4-20-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubewatch-0.0.4-20-linux-amd64-debian-9.tar.gz

##################

FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/kubewatch /opt/bitnami/kubewatch
ENV BITNAMI_APP_NAME="kubewatch" \
    BITNAMI_IMAGE_VERSION="0.0.4-debian-9-r135" \
    KW_CONFIG="/opt/bitnami/kubewatch" \
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
ENTRYPOINT [ "/entrypoint.sh" ]
