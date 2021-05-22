FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip iptables procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kiam-3.6.0-4-linux-amd64-debian-10.tar.gz && \
    echo "8826d04e2d03a5c9378830521487c324f36d2cdec20dbf0d1ff6c8cee6e9338d  /tmp/bitnami/pkg/cache/kiam-3.6.0-4-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kiam-3.6.0-4-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kiam-3.6.0-4-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami
RUN update-alternatives --set iptables /usr/sbin/iptables-legacy && \
    update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

ENV BITNAMI_APP_NAME="kiam" \
    BITNAMI_IMAGE_VERSION="3.6.0-debian-10-r206" \
    PATH="/opt/bitnami/kiam/bin:$PATH"

USER 1001
ENTRYPOINT [ "kiam" ]
CMD [ "--help" ]
