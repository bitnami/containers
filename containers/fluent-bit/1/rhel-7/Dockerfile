FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates glibc keyutils-libs krb5-libs libcom_err libgcc libselinux openssl-libs pcre wget zlib
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/fluent-bit-1.0.4-0-linux-x86_64-rhel-7.tar.gz && \
    echo "57950627d64ccef1f16df579a70d755143a0d03a5f25b9f07a8289058df7dc63  /tmp/bitnami/pkg/cache/fluent-bit-1.0.4-0-linux-x86_64-rhel-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/fluent-bit-1.0.4-0-linux-x86_64-rhel-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/fluent-bit-1.0.4-0-linux-x86_64-rhel-7.tar.gz

ENV BITNAMI_APP_NAME="fluent-bit" \
    BITNAMI_IMAGE_VERSION="1.0.4-rhel-7-r7" \
    BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/fluent-bit/bin:$PATH"

EXPOSE 2020

WORKDIR /opt/bitnami/fluent-bit
USER 1001
ENTRYPOINT [ "fluent-bit" ]
CMD [ "-c", "/opt/bitnami/fluent-bit/conf/fluent-bit.conf" ]
