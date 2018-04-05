FROM bitnami/minideb:jessie as development

ARG SERVICE_CATALOG_VERSION=0.1.11
ARG GO_VERSION=1.9.4
ARG DEP_VERSION=0.4.1

RUN install_packages wget ca-certificates git make tar wget gcc curl mercurial init-system-helpers libltdl7 libdevmapper-dev

RUN wget -nc https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz

ENV GOPATH=/tmp
ENV PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p /tmp/bin && \
    wget -nc https://github.com/golang/dep/releases/download/v$DEP_VERSION/dep-linux-amd64 && \
    chmod +x dep-linux-amd64 && \
    mv dep-linux-amd64 $GOPATH/bin/dep && \
    mkdir -p /tmp/src/github.com/kubernetes-incubator && \
    cd /tmp/src/github.com/kubernetes-incubator && \
    git clone -b v${SERVICE_CATALOG_VERSION} --depth 1 https://github.com/kubernetes-incubator/service-catalog.git && \
    cd service-catalog && \
    dep ensure -v && NO_DOCKER=1 make build

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

RUN install_packages ca-certificates

COPY --from=development /tmp/src/github.com/kubernetes-incubator/service-catalog/bin/service-catalog /opt/bitnami/service-catalog/bin/service-catalog
COPY --from=development /tmp/src/github.com/kubernetes-incubator/service-catalog/LICENSE /opt/bitnami/service-catalog/LICENSE

ENV PATH="/opt/bitnami/service-catalog/bin:$PATH"
WORKDIR    /opt/bitnami/service-catalog
USER 1001
ENTRYPOINT [ "/opt/bitnami/service-catalog/bin/service-catalog" ]
