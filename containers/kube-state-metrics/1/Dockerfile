FROM bitnami/minideb as development

ARG KSM_VERSION=1.2.0
ARG GO_VERSION=1.9.4

RUN install_packages wget ca-certificates git make tar wget gcc

RUN wget -nc https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz

ENV GOPATH=/
ENV PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p /src/k8s.io && \
    cd /src/k8s.io && \
    git clone  -b v${KSM_VERSION} --depth 1 https://github.com/kubernetes/kube-state-metrics.git && \
    cd /src/k8s.io/kube-state-metrics  && \
    make build

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /src/k8s.io/kube-state-metrics/kube-state-metrics /opt/bitnami/kube-state-metrics/bin/kube-state-metrics
COPY --from=development /src/k8s.io/kube-state-metrics/LICENSE /opt/bitnami/kube-state-metrics/LICENSE

ENV PATH="/opt/bitnami/kube-state-metrics/bin:$PATH"
EXPOSE 8080 8081
USER 1001
WORKDIR    /opt/bitnami/kube-state-metrics
ENTRYPOINT ["/opt/bitnami/kube-state-metrics/bin/kube-state-metrics", "--port=8080", "--telemetry-port=8081"]
