FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libbz2-1.0 libc6 libffi6 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libtinfo6 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-3.7.13-2-linux-amd64-debian-10.tar.gz && \
    echo "3d9135de077d698658de5a6ff002895d4fc15bac71f02fe910b8df45acbd2ec6  /tmp/bitnami/pkg/cache/python-3.7.13-2-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-3.7.13-2-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-3.7.13-2-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/google-cloud-sdk-0.378.0-0-linux-amd64-debian-10.tar.gz && \
    echo "ce852ac802c6a9c8fc6e075eba9ce4175fc1a2cee12ef9bc45e1195c4798fded  /tmp/bitnami/pkg/cache/google-cloud-sdk-0.378.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/google-cloud-sdk-0.378.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/google-cloud-sdk-0.378.0-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /.config /.gsutil && chmod g+rwX /.config /.gsutil

ENV APP_VERSION="0.378.0" \
    BITNAMI_APP_NAME="google-cloud-sdk" \
    BITNAMI_IMAGE_VERSION="0.378.0-debian-10-r6" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/google-cloud-sdk/bin:$PATH"

USER 1001
ENTRYPOINT [ "gcloud" ]
CMD [ "--help" ]
