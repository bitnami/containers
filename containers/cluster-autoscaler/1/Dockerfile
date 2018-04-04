FROM bitnami/minideb:jessie as development

ARG AUTOSCALER_VERSION=1.2.0
ARG GO_VERSION=1.9.4

RUN install_packages wget ca-certificates git tar build-essential

RUN wget -nc https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz

ENV PATH=/usr/local/go/bin:$PATH
ENV GOPATH=/
ENV PATH=$GOPATH/bin:$PATH


RUN mkdir -p /src/k8s.io/ && \
    cd /src/k8s.io/ && \
    git clone https://github.com/kubernetes/autoscaler.git && \
    cd autoscaler/cluster-autoscaler && \
    git checkout tags/cluster-autoscaler-$AUTOSCALER_VERSION && \
    make

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

RUN install_packages ca-certificates

COPY --from=development /src/k8s.io/autoscaler/cluster-autoscaler/cluster-autoscaler /opt/bitnami/cluster-autoscaler/bin/cluster-autoscaler
COPY rootfs/run.sh run.sh

RUN mkdir -p /opt/bitnami/cluster-autoscaler/log/

ENV PATH="/opt/bitnami/cluster-autoscaler/bin:$PATH"
WORKDIR    /opt/bitnami/cluster-autoscaler/

CMD ["/run.sh"]
