FROM bitnami/ruby:latest-prod as buildenv

RUN install_packages ca-certificates libc6 libgcc1 libstdc++6 wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/fluentd-1.2.2-2-linux-x64-debian-8.tar.gz && \
    echo "18ffed6b73ecfdf8670c1787fec771ff30a585eba357a2416187221f8dd465b5  /tmp/bitnami/pkg/cache/fluentd-1.2.2-2-linux-x64-debian-8.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/fluentd-1.2.2-2-linux-x64-debian-8.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/fluentd-1.2.2-2-linux-x64-debian-8.tar.gz

##################

FROM bitnami/ruby:latest-prod
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/fluentd /opt/bitnami/fluentd
ENV BITNAMI_APP_NAME="fluentd" \
    BITNAMI_IMAGE_VERSION="1.2.2-r21" \
    GEM_HOME="/opt/bitnami/fluentd" \
    PATH="/opt/bitnami/fluentd/bin:$PATH"

RUN install_packages ca-certificates libjemalloc-dev
RUN chmod g+rwX /opt/bitnami/fluentd/conf /opt/bitnami/fluentd/logs

EXPOSE 24224 5140

COPY rootfs /
WORKDIR /opt/bitnami/fluentd
USER 1001
ENTRYPOINT ["/entrypoint.sh"]
CMD ["fluentd","-c","/opt/bitnami/fluentd/conf/fluentd.conf","-p","/opt/bitnami/fluentd/plugins"]
