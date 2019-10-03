FROM bitnami/ruby:2.6-ol-7-prod
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates glibc libgcc libjemalloc-dev libstdc++ wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/fluentd-1.7.3-0-linux-x86_64-ol-7.tar.gz && \
    echo "3b0e66da1a66439f85dbf4a4d4c55c39ccb28a8f69b22d45e59b318494c52052  /tmp/bitnami/pkg/cache/fluentd-1.7.3-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/fluentd-1.7.3-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/fluentd-1.7.3-0-linux-x86_64-ol-7.tar.gz
RUN chmod g+rwX /opt/bitnami/fluentd/conf /opt/bitnami/fluentd/logs

COPY rootfs /
ENV BITNAMI_APP_NAME="fluentd" \
    BITNAMI_IMAGE_VERSION="1.7.3-ol-7-r2" \
    FLUENTD_CONF="fluentd.conf" \
    FLUENTD_OPT="" \
    GEM_HOME="/opt/bitnami/fluentd" \
    PATH="/opt/bitnami/fluentd/bin:$PATH"

EXPOSE 24224 5140

WORKDIR /opt/bitnami/fluentd
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "fluentd", "-c", "/opt/bitnami/fluentd/conf/${FLUENTD_CONF}", "-p", "/opt/bitnami/fluentd/plugins", "$FLUENTD_OPT" ]
