FROM bitnami/minideb-extras:jessie-r14-buildpack as build

ARG SRC_REPO=github.com/bitly/oauth2_proxy
ARG SRC_TAG=v2.2
ARG BINARY=oauth2_proxy

RUN bitnami-pkg install go-1.8.7-0 --checksum b4f95f751cfee5dfc82820327089c7a9afd09ecadb41894189e5925ed61c1390
RUN install_packages ca-certificates

ENV GOPATH=/gopath
ENV PATH=$GOPATH/bin:/opt/bitnami/go/bin:$PATH

# Checkout specific version:
## Download
RUN go get -d ${SRC_REPO}
## Branch
RUN git -C ${GOPATH}/src/${SRC_REPO} checkout -b build-${SRC_TAG} ${SRC_TAG}
## Build from workdirs
RUN go get ${SRC_REPO}

FROM bitnami/minideb:stretch
MAINTAINER Bitnami <containers@bitnami.com>

USER 1001
EXPOSE 8080 4180
COPY --from=build /gopath/bin/oauth2_proxy /opt/bitnami/oauth2_proxy/bin/oauth2_proxy
COPY --from=build /etc/ssl/certs /etc/ssl/certs
COPY --from=build /usr/share/ca-certificates /usr/share/ca-certificates

ENTRYPOINT [ "/opt/bitnami/oauth2_proxy/bin/oauth2_proxy" ]
CMD [ "--upstream=http://0.0.0.0:8080/", "--http-address=0.0.0.0:4180" ]
