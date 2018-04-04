FROM bitnami/ruby:2.5 as development

ARG FLUENTD_VERSION=1.1.2

RUN gem install --install-dir /opt/bitnami/fluentd oj -v 3.3.10 -N && \
    gem install --install-dir /opt/bitnami/fluentd json -v 2.1.0 -N && \
    gem install --install-dir /opt/bitnami/fluentd fluentd -v $FLUENTD_VERSION -N

RUN wget -O /tmp/jemalloc-4.5.0.tar.bz2 https://github.com/jemalloc/jemalloc/releases/download/4.5.0/jemalloc-4.5.0.tar.bz2 && \
    cd /tmp && tar -xjf jemalloc-4.5.0.tar.bz2 && cd jemalloc-4.5.0/ && \
    ./configure --prefix=/usr && make && make install

RUN mkdir -p /opt/bitnami/fluentd/logs /opt/bitnami/fluentd/plugins
COPY rootfs/fluent.conf /opt/bitnami/fluentd/conf/fluent.conf

FROM bitnami/ruby:2.5-prod
LABEL maintainer "Bitnami <containers@bitnami.com>"

RUN install_packages libssl1.0.0

COPY --from=development /opt/bitnami/fluentd /opt/bitnami/fluentd
COPY --from=development /usr/lib/libjemalloc.so.2 /usr/lib/libjemalloc.so.2

RUN chmod g+rwX /opt/bitnami/fluentd/logs

ENV PATH="/opt/bitnami/fluentd/bin:$PATH"
ENV GEM_HOME="/opt/bitnami/fluentd"
ENV LD_PRELOAD="/usr/lib/libjemalloc.so.2"

USER 1001
EXPOSE 24224 5140
WORKDIR /opt/bitnami/fluentd

CMD ["fluentd", "-c", "/opt/bitnami/fluentd/conf/fluent.conf", "-p", "/opt/bitnami/fluentd/plugins" ]
