FROM bitnami/ruby:2.5-ol-7 as buildenv

RUN install_packages ca-certificates glibc nss-softokn-freebl wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/fluentd-1.2.2-0-linux-x86_64-ol-7.tar.gz && \
    echo "978bb6f6cd7fbe9e2eb815b457a30ca679cc2a0db3138b82b86642b4855e214e  /tmp/bitnami/pkg/cache/fluentd-1.2.2-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/fluentd-1.2.2-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/fluentd-1.2.2-0-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/ruby:2.5-ol-7
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/fluentd /opt/bitnami/fluentd
ENV BITNAMI_APP_NAME="fluentd" \
    BITNAMI_IMAGE_VERSION="1.2.2-ol-7-r2" \
    GEM_HOME="/opt/bitnami/fluentd" \
    PATH="/opt/bitnami/fluentd/bin:$PATH"

RUN install_packages ca-certificates libjemalloc-dev
RUN chmod g+rwX /opt/bitnami/fluentd/logs

EXPOSE 24224 5140

WORKDIR /opt/bitnami/fluentd
USER 1001
CMD ["fluentd","-c","/opt/bitnami/fluentd/conf/fluentd.conf","-p","/opt/bitnami/fluentd/plugins"]
