FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates glibc wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/cert-manager-0.6.1-0-linux-x86_64-rhel-7.tar.gz && \
    echo "3e48159e445e235d922f5032bd1314439aabe201bb275cb1865e3d670eae91de  /tmp/bitnami/pkg/cache/cert-manager-0.6.1-0-linux-x86_64-rhel-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/cert-manager-0.6.1-0-linux-x86_64-rhel-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/cert-manager-0.6.1-0-linux-x86_64-rhel-7.tar.gz

ENV BITNAMI_APP_NAME="cert-manager" \
    BITNAMI_IMAGE_VERSION="0.6.1-rhel-7-r0" \
    BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/cert-manager/bin:$PATH"

WORKDIR /opt/bitnami/cert-manager
USER 1001
ENTRYPOINT [ "/opt/bitnami/cert-manager/bin/cert-manager" ]
