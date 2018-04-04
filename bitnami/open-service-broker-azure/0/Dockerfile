
FROM bitnami/minideb:jessie as development

ENV BASE_PACKAGE_NAME=github.com/Azure/open-service-broker-azure
ENV LDFLAGS=-"w -X $(BASE_PACKAGE_NAME)/pkg/version.commit=$(GIT_VERSION) -X $(BASE_PACKAGE_NAME)/pkg/version.version=$(BROKER_VERSION)"

ARG BROKER_VERSION=0.9.0-alpha
ARG GO_VERSION=1.9.4

RUN install_packages wget ca-certificates git make tar wget

RUN wget -nc https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz

ENV GOPATH=/
ENV PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p /src/github.com/Azure/ && \
    cd /src/github.com/Azure/ && \
    git clone -b v${BROKER_VERSION} --depth 1  https://$BASE_PACKAGE_NAME.git && \
    cd open-service-broker-azure && \
    go build -o bin/broker -ldflags "$LDFLAGS" ./cmd/broker

FROM bitnami/minideb:jessie
ARG BASE_PACKAGE_NAME=github.com/Azure/open-service-broker-azure
COPY --from=development /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=development /src/$BASE_PACKAGE_NAME/bin/broker /opt/bitnami/open-service-broker-azure/bin/broker
COPY --from=development /src/$BASE_PACKAGE_NAME/LICENSE /opt/bitnami/open-service-broker-azure/LICENSE

ENV PATH=/opt/bitnami/open-service-broker-azure/bin/:$PATH

EXPOSE 8080
USER 1001
CMD ["/opt/bitnami/open-service-broker-azure/bin/broker"]
