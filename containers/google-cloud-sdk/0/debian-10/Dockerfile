FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libbz2-1.0 libc6 libffi6 libgcc1 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-3.7.7-7-linux-amd64-debian-10.tar.gz && \
    echo "e12699c7a5e60ae44d565c4796b9710a815803c2d6c282778a6952edf3c4382a  /tmp/bitnami/pkg/cache/python-3.7.7-7-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-3.7.7-7-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-3.7.7-7-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/google-cloud-sdk-0.293.0-0-linux-amd64-debian-10.tar.gz && \
    echo "bee8828977260e64007a79ba5c5ff9b1d110e0456a95ea61238d07566f282f7b  /tmp/bitnami/pkg/cache/google-cloud-sdk-0.293.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/google-cloud-sdk-0.293.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/google-cloud-sdk-0.293.0-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN mkdir /.config /.gsutil && chmod g+rwX /.config /.gsutil

ENV BITNAMI_APP_NAME="google-cloud-sdk" \
    BITNAMI_IMAGE_VERSION="0.293.0-debian-10-r0" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/google-cloud-sdk/bin:$PATH"

USER 1001
ENTRYPOINT [ "gcloud" ]
CMD [ "--help" ]
