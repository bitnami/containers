FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip iptables procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kiam-4.0.0-0-linux-amd64-debian-10.tar.gz && \
    echo "eaf16bbe5042e5b334d0a92515c0fea1acd97de2f08271f7f51a009da3e90c04  /tmp/bitnami/pkg/cache/kiam-4.0.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kiam-4.0.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kiam-4.0.0-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN update-alternatives --set iptables /usr/sbin/iptables-legacy && \
    update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

ENV BITNAMI_APP_NAME="kiam" \
    BITNAMI_IMAGE_VERSION="4.0.0-debian-10-r2" \
    PATH="/opt/bitnami/kiam/bin:$PATH"

USER 1001
ENTRYPOINT [ "kiam" ]
CMD [ "--help" ]
