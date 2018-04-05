FROM bitnami/minideb:jessie as development

ARG CERT_MANAGER_VERSION=0.2.3
ARG DEP_VERSION=0.4.1
ARG GO_VERSION=1.9.4

RUN install_packages wget ca-certificates git make tar wget gcc curl libltdl7 libdevmapper-dev

RUN wget -nc https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz

ENV GOPATH=/
ENV PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

RUN wget -nc https://github.com/golang/dep/releases/download/v$DEP_VERSION/dep-linux-amd64 && \
    chmod +x dep-linux-amd64 && \
    mv dep-linux-amd64 $GOPATH/bin/dep

RUN mkdir -p /src/ && \
    cd /src/ && \
    git clone -b v${CERT_MANAGER_VERSION} --depth 1 https://github.com/jetstack/cert-manager.git && \
    cd cert-manager && \
    dep ensure -v && \
    make acmesolver

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

RUN install_packages ca-certificates

COPY --from=development /src/cert-manager/hack/build/dockerfiles/cert-manager-acmesolver_linux_amd64 /opt/bitnami/cert-manager/bin/acmesolver

ENV PATH="/opt/bitnami/cert-manager/bin:$PATH"
WORKDIR    /opt/bitnami/cert-manager

USER 1001
ENTRYPOINT ["/opt/bitnami/cert-manager/bin/acmesolver"]
