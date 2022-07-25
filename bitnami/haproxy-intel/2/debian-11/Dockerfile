FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libssl1.1 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/qatengine-0.6.14-0-linux-amd64-debian-11.tar.gz && \
    echo "1d3dbcc9f98ad8373674cb3d725682061a04e321626ad750a9f73f4b1004d502  /tmp/bitnami/pkg/cache/qatengine-0.6.14-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/qatengine-0.6.14-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/qatengine-0.6.14-0-linux-amd64-debian-11.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/haproxy-dataplaneapi-2.5.4-1-linux-amd64-debian-11.tar.gz && \
    echo "d72aaba5cd9fc7d387875fd8968f4530b76099daa7b161169e66266a401ac77e  /tmp/bitnami/pkg/cache/haproxy-dataplaneapi-2.5.4-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/haproxy-dataplaneapi-2.5.4-1-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/haproxy-dataplaneapi-2.5.4-1-linux-amd64-debian-11.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/haproxy-2.6.2-0-linux-amd64-debian-11.tar.gz && \
    echo "9aa7be08d311a143594a2ebbb6bc112938a79bc2c75fc98223658248bae8fd92  /tmp/bitnami/pkg/cache/haproxy-2.6.2-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/haproxy-2.6.2-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/haproxy-2.6.2-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/common/lib/engines-1.1/* /usr/lib/x86_64-linux-gnu/engines-1.1/

ENV APP_VERSION="2.6.2" \
    BITNAMI_APP_NAME="haproxy-intel" \
    PATH="/opt/bitnami/haproxy-dataplaneapi/bin:/opt/bitnami/haproxy/sbin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/haproxy/sbin/haproxy" ]
CMD [ "-f", "/bitnami/haproxy/conf/haproxy.cfg" ]
