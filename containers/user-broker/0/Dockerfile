FROM bitnami/minideb:jessie as development

ARG SERVICE_CATALOG_VERSION=0.1.20
ARG DEP_VERSION=0.4.1
ARG GO_VERSION=1.9.4

RUN install_packages wget ca-certificates git make tar gcc curl mercurial init-system-helpers libltdl7 libdevmapper-dev

RUN wget -nc https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz

ENV GOPATH=/tmp
ENV PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

RUN go get -u github.com/golang/dep/cmd/dep && \
    mkdir -p /tmp/src/github.com/kubernetes-incubator && \
    cd /tmp/src/github.com/kubernetes-incubator && \
    git clone -b v${SERVICE_CATALOG_VERSION} --depth 1 https://github.com/kubernetes-incubator/service-catalog.git && \
    cd service-catalog && \
    dep ensure -v && NO_DOCKER=1 make user-broker

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

RUN install_packages ca-certificates

COPY --from=development /tmp/src/github.com/kubernetes-incubator/service-catalog/bin/user-broker /opt/bitnami/user-broker/bin/user-broker
COPY --from=development /tmp/src/github.com/kubernetes-incubator/service-catalog/LICENSE /opt/bitnami/user-broker/LICENSE

ENV PATH="/opt/bitnami/user-broker/bin:$PATH"
WORKDIR    /opt/bitnami/user-broker
USER 1001
ENTRYPOINT [ "/opt/bitnami/user-broker/bin/user-broker" ]
