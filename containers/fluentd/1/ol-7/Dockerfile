FROM bitnami/ruby:2.5-ol-7 as buildenv

RUN install_packages ca-certificates glibc libgcc libstdc++ nss-softokn-freebl wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/fluentd-1.2.4-0-linux-x86_64-ol-7.tar.gz && \
    echo "4f8f520bc7d6204e4da96e603f873bda7d2e4333aafb5509cee7233147ca629b  /tmp/bitnami/pkg/cache/fluentd-1.2.4-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/fluentd-1.2.4-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/fluentd-1.2.4-0-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/ruby:2.5-ol-7
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/fluentd /opt/bitnami/fluentd
ENV BITNAMI_APP_NAME="fluentd" \
    BITNAMI_IMAGE_VERSION="1.2.4-ol-7-r2" \
    FLUENTD_CONF="fluentd.conf" \
    FLUENTD_OPT="" \
    GEM_HOME="/opt/bitnami/fluentd" \
    PATH="/opt/bitnami/fluentd/bin:$PATH"

RUN install_packages ca-certificates libjemalloc-dev
RUN chmod g+rwX /opt/bitnami/fluentd/conf /opt/bitnami/fluentd/logs

EXPOSE 24224 5140

COPY rootfs /
WORKDIR /opt/bitnami/fluentd
USER 1001
ENTRYPOINT ["/entrypoint.sh"]
CMD ["fluentd","-c","/opt/bitnami/fluentd/conf/${FLUENTD_CONF}","-p","/opt/bitnami/fluentd/plugins","$FLUENTD_OPT"]
