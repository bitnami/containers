FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libbz2-1.0 libc6 libffi6 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libtinfo6 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-3.7.10-1-linux-amd64-debian-10.tar.gz && \
    echo "2a6fa2764026a933a1e9517adbc372a37862ba74fda5f4a6c3d32122928c216e  /tmp/bitnami/pkg/cache/python-3.7.10-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-3.7.10-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-3.7.10-1-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/google-cloud-sdk-0.334.0-0-linux-amd64-debian-10.tar.gz && \
    echo "8219d163bc6847e35f251f3d86643f563d3dd3c68615ba2f511236190937842f  /tmp/bitnami/pkg/cache/google-cloud-sdk-0.334.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/google-cloud-sdk-0.334.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/google-cloud-sdk-0.334.0-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami
RUN mkdir /.config /.gsutil && chmod g+rwX /.config /.gsutil

ENV BITNAMI_APP_NAME="google-cloud-sdk" \
    BITNAMI_IMAGE_VERSION="0.334.0-debian-10-r1" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/google-cloud-sdk/bin:$PATH"

USER 1001
ENTRYPOINT [ "gcloud" ]
CMD [ "--help" ]
