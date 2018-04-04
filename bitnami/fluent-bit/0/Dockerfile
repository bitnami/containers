FROM bitnami/minideb:jessie as development

ARG FLB_VERSION=0.12.16

RUN mkdir -p /opt/bitnami/fluent-bit/bin /opt/bitnami/fluent-bit/conf /opt/bitnami/fluent-bit/log /tmp/src/

RUN install_packages ca-certificates build-essential cmake make wget unzip libsystemd-dev libssl-dev git

RUN cd /tmp/src && \
    git clone -b v${FLB_VERSION} --depth 1 https://github.com/fluent/fluent-bit.git && \
    cd fluent-bit && \
    cd /tmp/src/fluent-bit && \
    cmake -DFLB_DEBUG=Off \
          -DFLB_TRACE=Off \
          -DFLB_JEMALLOC=On \
          -DFLB_BUFFERING=On \
          -DFLB_TLS=On \
          -DFLB_WITHOUT_SHARED_LIB=On \
          -DFLB_WITHOUT_EXAMPLES=On \
          -DFLB_HTTP_SERVER=On \
          -DFLB_OUT_KAFKA=On . &&\
    make && \
    install bin/fluent-bit /opt/bitnami/fluent-bit/bin/

RUN cp /tmp/src/fluent-bit/conf/fluent-bit.conf /tmp/src/fluent-bit/conf/parsers.conf /tmp/src/fluent-bit/conf/parsers_java.conf /opt/bitnami/fluent-bit/conf/

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

RUN install_packages ca-certificates libssl1.0.0

COPY --from=development /opt/bitnami/fluent-bit /opt/bitnami/fluent-bit

EXPOSE 2020
USER 1001
CMD ["/opt/bitnami/fluent-bit/bin/fluent-bit", "-c", "/opt/bitnami/fluent-bit/conf/fluent-bit.conf"]
