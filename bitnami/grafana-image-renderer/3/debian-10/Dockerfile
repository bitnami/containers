FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl fonts-freefont-ttf fonts-ipafont-gothic fonts-kacst fonts-thai-tlwg fonts-wqy-zenhei gnupg gzip jq libbz2-1.0 libc6 libffi6 libgcc1 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 libx11-xcb1 libxcb-dri3-0 libxshmfence1 libxss1 libxtst6 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-3.8.12-35-linux-amd64-debian-10.tar.gz && \
    echo "338b60596e8a45b8a55ab2831bcc05a804d423da70c296e737c41616ab11f104  /tmp/bitnami/pkg/cache/python-3.8.12-35-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-3.8.12-35-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-3.8.12-35-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/node-14.19.0-3-linux-amd64-debian-10.tar.gz && \
    echo "d1c0e36b98ba6464fcf517c50d35d212d8bf7626cd99838f361bbe1c47319e5e  /tmp/bitnami/pkg/cache/node-14.19.0-3-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/node-14.19.0-3-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/node-14.19.0-3-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/grafana-image-renderer-3.4.1-0-linux-amd64-debian-10.tar.gz && \
    echo "764cec63aad42a50864acc7687069d47e0577ff21fd8bacb5ce38c9bea07a063  /tmp/bitnami/pkg/cache/grafana-image-renderer-3.4.1-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/grafana-image-renderer-3.4.1-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/grafana-image-renderer-3.4.1-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list.d/google.list && \
    install_packages google-chrome-unstable

ENV BITNAMI_APP_NAME="grafana-image-renderer" \
    BITNAMI_IMAGE_VERSION="3.4.1-debian-10-r0" \
    HTTP_HOST="0.0.0.0" \
    HTTP_PORT="8080" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:$PATH"

EXPOSE 3000 8080

WORKDIR /opt/bitnami/grafana-image-renderer
USER 1001
ENTRYPOINT [ "node" ]
CMD [ "build/app.js", "server", "--config=conf/config.json" ]
