FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates glibc wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/cert-manager-0.7.0-0-linux-x86_64-rhel-7.tar.gz && \
    echo "1f1d286f69a3bd906f669b3963de6ac495a4279d23aa5629681b4cb185aa13b9  /tmp/bitnami/pkg/cache/cert-manager-0.7.0-0-linux-x86_64-rhel-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/cert-manager-0.7.0-0-linux-x86_64-rhel-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/cert-manager-0.7.0-0-linux-x86_64-rhel-7.tar.gz

ENV BITNAMI_APP_NAME="cert-manager" \
    BITNAMI_IMAGE_VERSION="0.7.0-rhel-7-r17" \
    BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/cert-manager/bin:$PATH"

WORKDIR /opt/bitnami/cert-manager
USER 1001
ENTRYPOINT [ "/opt/bitnami/cert-manager/bin/cert-manager" ]
