FROM bitnami/ruby:2.5-ol-7 as buildenv

RUN install_packages ca-certificates glibc nss-softokn-freebl wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/fluentd-1.2.2-1-linux-x86_64-ol-7.tar.gz && \
    echo "029603a60845402c333a066afcc4c76150b8060736ce7f6079521219e850a27f  /tmp/bitnami/pkg/cache/fluentd-1.2.2-1-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/fluentd-1.2.2-1-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/fluentd-1.2.2-1-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/ruby:2.5-ol-7
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/fluentd /opt/bitnami/fluentd
ENV BITNAMI_APP_NAME="fluentd" \
    BITNAMI_IMAGE_VERSION="1.2.2-ol-7-r5" \
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
