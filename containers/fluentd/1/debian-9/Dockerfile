FROM bitnami/ruby:2.6-prod
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates libc6 libgcc1 libjemalloc-dev libncurses5-dev libreadline-dev libssl1.0.2 libstdc++6 wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/fluentd-1.7.0-1-linux-amd64-debian-9.tar.gz && \
    echo "6a2f4360bce082a434ee9b02576cf7c6df1c10752edf533cb2f25ee904dd3606  /tmp/bitnami/pkg/cache/fluentd-1.7.0-1-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/fluentd-1.7.0-1-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/fluentd-1.7.0-1-linux-amd64-debian-9.tar.gz
RUN chmod g+rwX /opt/bitnami/fluentd/conf /opt/bitnami/fluentd/logs

COPY rootfs /
ENV BITNAMI_APP_NAME="fluentd" \
    BITNAMI_IMAGE_VERSION="1.7.0-debian-9-r17" \
    FLUENTD_CONF="fluentd.conf" \
    FLUENTD_OPT="" \
    GEM_HOME="/opt/bitnami/fluentd" \
    PATH="/opt/bitnami/fluentd/bin:$PATH"

EXPOSE 24224 5140

WORKDIR /opt/bitnami/fluentd
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "fluentd", "-c", "/opt/bitnami/fluentd/conf/${FLUENTD_CONF}", "-p", "/opt/bitnami/fluentd/plugins", "$FLUENTD_OPT" ]
