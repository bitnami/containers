FROM bitnami/ruby:latest-prod as buildenv

RUN install_packages ca-certificates libc6 libgcc1 libstdc++6 wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/fluentd-1.2.3-0-linux-amd64-debian-9.tar.gz && \
    echo "c2818ccfc89f6824643ead61da721c7affe7a5240c704862ce0e53b845b77188  /tmp/bitnami/pkg/cache/fluentd-1.2.3-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/fluentd-1.2.3-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/fluentd-1.2.3-0-linux-amd64-debian-9.tar.gz

##################

FROM bitnami/ruby:latest-prod
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/fluentd /opt/bitnami/fluentd
ENV BITNAMI_APP_NAME="fluentd" \
    BITNAMI_IMAGE_VERSION="1.2.3-debian-9-r23" \
    FLUENTD_CONF="fluentd.conf" \
    FLUENTD_OPT="" \
    GEM_HOME="/opt/bitnami/fluentd" \
    PATH="/opt/bitnami/fluentd/bin:$PATH"

RUN install_packages ca-certificates libjemalloc-dev
RUN install_packages libreadline-dev libncurses5-dev
RUN chmod g+rwX /opt/bitnami/fluentd/conf /opt/bitnami/fluentd/logs

EXPOSE 24224 5140

COPY rootfs /
WORKDIR /opt/bitnami/fluentd
USER 1001
ENTRYPOINT ["/entrypoint.sh"]
CMD ["fluentd","-c","/opt/bitnami/fluentd/conf/${FLUENTD_CONF}","-p","/opt/bitnami/fluentd/plugins","$FLUENTD_OPT"]
