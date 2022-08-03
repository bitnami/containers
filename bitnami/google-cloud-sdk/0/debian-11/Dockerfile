FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libbz2-1.0 libc6 libcom-err2 libcrypt1 libffi7 libgssapi-krb5-2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblzma5 libncursesw6 libnsl2 libreadline8 libsqlite3-0 libssl1.1 libtinfo6 libtirpc3 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-3.7.13-159-linux-amd64-debian-11.tar.gz && \
    echo "74655c2cfaec3d561ec24367dac4c25d633f7e17281f445a43196b597a137863  /tmp/bitnami/pkg/cache/python-3.7.13-159-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-3.7.13-159-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-3.7.13-159-linux-amd64-debian-11.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/google-cloud-sdk-0.396.0-0-linux-amd64-debian-11.tar.gz && \
    echo "b0c1081f670f9e137113ff04f46c0149766bf5a186316d675c9902f27182cdf9  /tmp/bitnami/pkg/cache/google-cloud-sdk-0.396.0-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/google-cloud-sdk-0.396.0-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/google-cloud-sdk-0.396.0-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /.config /.gsutil && chmod g+rwX /.config /.gsutil

ENV APP_VERSION="0.396.0" \
    BITNAMI_APP_NAME="google-cloud-sdk" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/google-cloud-sdk/bin:$PATH"

USER 1001
ENTRYPOINT [ "gcloud" ]
CMD [ "--help" ]
