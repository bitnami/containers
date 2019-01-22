FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates glibc wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubewatch-0.0.4-0-linux-x86_64-rhel-7.tar.gz && \
    echo "72ec8059c57b3c325d51feef5ec34dd0a48dddaa04e93146335f97c8ea73aa5c  /tmp/bitnami/pkg/cache/kubewatch-0.0.4-0-linux-x86_64-rhel-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubewatch-0.0.4-0-linux-x86_64-rhel-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubewatch-0.0.4-0-linux-x86_64-rhel-7.tar.gz

COPY rootfs /
RUN chmod g+rwX /opt/bitnami/kubewatch/
ENV BITNAMI_APP_NAME="kubewatch" \
    BITNAMI_IMAGE_VERSION="0.0.4-rhel-7-r0" \
    BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
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
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/kubewatch/bin:$PATH"

WORKDIR /opt/bitnami/kubewatch
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
