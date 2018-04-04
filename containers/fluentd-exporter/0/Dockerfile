FROM bitnami/minideb:jessie as development

ARG FLUENTD_EXPORTER_VERSION=0.1.0
ARG GO_VERSION=1.9.4

RUN install_packages wget ca-certificates git make tar wget

RUN wget -nc https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz

ENV GOPATH=/
ENV PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p /src/ && \
    cd /src/ && \
    git clone -b ${FLUENTD_EXPORTER_VERSION} --depth 1 https://github.com/V3ckt0r/fluentd_exporter.git && \
    cd fluentd_exporter && \
    go build fluentd_exporter.go

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /src/fluentd_exporter/fluentd_exporter /opt/bitnami/fluentd_exporter/bin/fluentd_exporter
COPY --from=development /src/fluentd_exporter/LICENSE /opt/bitnami/fluentd_exporter/LICENSE

ENV PATH="/opt/bitnami/fluentd_exporter/bin:$PATH"
EXPOSE 9309
WORKDIR    /opt/bitnami/fluentd_exporter
USER 1001
ENTRYPOINT [ "/opt/bitnami/fluentd_exporter/bin/fluentd_exporter" ]
