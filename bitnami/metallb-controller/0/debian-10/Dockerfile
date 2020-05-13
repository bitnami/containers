FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 procps sudo unzip wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/metallb-controller-0.9.3-0-linux-amd64-debian-10.tar.gz && \
    echo "d1630eab4159467b8bb334b34cb8d1512d469f26f4a5b6f0e047e8b86edfe33c  /tmp/bitnami/pkg/cache/metallb-controller-0.9.3-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/metallb-controller-0.9.3-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/metallb-controller-0.9.3-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

ENV BITNAMI_APP_NAME="metallb-controller" \
    BITNAMI_IMAGE_VERSION="0.9.3-debian-10-r44" \
    PATH="/opt/bitnami/metallb-controller/bin:$PATH"

USER 1001
ENTRYPOINT [ "controller" ]
CMD [ "--help" ]
