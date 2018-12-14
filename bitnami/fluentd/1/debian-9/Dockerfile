FROM bitnami/ruby:latest-prod as buildenv

RUN install_packages ca-certificates libc6 libgcc1 libstdc++6 wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/fluentd-1.3.2-0-linux-amd64-debian-9.tar.gz && \
    echo "e38833c77be62183ab74dd80eb9dec3f4063fa4caff88e14e17b3df89ed8d812  /tmp/bitnami/pkg/cache/fluentd-1.3.2-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/fluentd-1.3.2-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/fluentd-1.3.2-0-linux-amd64-debian-9.tar.gz

##################

FROM bitnami/ruby:latest-prod
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/fluentd /opt/bitnami/fluentd
ENV BITNAMI_APP_NAME="fluentd" \
    BITNAMI_IMAGE_VERSION="1.3.2-debian-9-r2" \
    FLUENTD_CONF="fluentd.conf" \
    FLUENTD_OPT="" \
    GEM_HOME="/opt/bitnami/fluentd" \
    PATH="/opt/bitnami/fluentd/bin:$PATH"

RUN install_packages ca-certificates libjemalloc-dev
RUN install_packages libreadline-dev libncurses5-dev libssl1.0.2
RUN chmod g+rwX /opt/bitnami/fluentd/conf /opt/bitnami/fluentd/logs

EXPOSE 24224 5140

COPY rootfs /
WORKDIR /opt/bitnami/fluentd
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "fluentd", "-c", "/opt/bitnami/fluentd/conf/${FLUENTD_CONF}", "-p", "/opt/bitnami/fluentd/plugins", "$FLUENTD_OPT" ]
