FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates curl dbus-libs elfutils-libelf elfutils-libs expat fontconfig fontconfig-devel glib2 glibc gzip hostname libaio-devel libattr libblkid libcap libffi libgcc libgcrypt libgpg-error libmount libselinux libstdc++ libuuid lz4 nspr nss nss-util pcre procps-ng sudo systemd-libs tar wget which xz-libs zlib
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/grafana-6.5.2-0-linux-x86_64-ol-7.tar.gz && \
    echo "9f1de5b3c6c15ad28c6ff7877e43e4ee522bb86b4d8d81dcae951b1ad7263862  /tmp/bitnami/pkg/cache/grafana-6.5.2-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/grafana-6.5.2-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/grafana-6.5.2-0-linux-x86_64-ol-7.tar.gz
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN mv /opt/bitnami/grafana/conf/sample.ini /opt/bitnami/grafana/conf/grafana.ini
RUN mkdir -p /opt/bitnami/grafana/data/ /opt/bitnami/grafana/logs/ && chmod g+rwX /opt/bitnami/grafana/data/ /opt/bitnami/grafana/logs/

COPY rootfs /
RUN /grafana-plugins.sh
ENV BITNAMI_APP_NAME="grafana" \
    BITNAMI_IMAGE_VERSION="6.5.2-ol-7-r28" \
    PATH="/opt/bitnami/grafana/bin:$PATH"

EXPOSE 3000

WORKDIR /opt/bitnami/grafana
USER 1001
ENTRYPOINT [ "/run.sh" ]
