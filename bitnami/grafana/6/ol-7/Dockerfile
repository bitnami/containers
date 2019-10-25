FROM bitnami/oraclelinux-extras:7-r508
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates curl dbus-libs elfutils-libelf elfutils-libs expat fontconfig fontconfig-devel glib2 glibc libattr libblkid libcap libffi libgcc libgcrypt libgpg-error libmount libselinux libstdc++ libuuid lz4 nspr nss nss-util pcre systemd-libs wget xz-libs zlib
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/grafana-6.4.3-0-linux-x86_64-ol-7.tar.gz && \
    echo "26e24db2c752289274b3677d01e73bd06b2e7905fb99fc8ea2102d1ecc81ac8c  /tmp/bitnami/pkg/cache/grafana-6.4.3-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/grafana-6.4.3-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/grafana-6.4.3-0-linux-x86_64-ol-7.tar.gz
RUN mv /opt/bitnami/grafana/conf/sample.ini /opt/bitnami/grafana/conf/grafana.ini
RUN mkdir -p /opt/bitnami/grafana/data/ /opt/bitnami/grafana/logs/ && chmod g+rwX /opt/bitnami/grafana/data/ /opt/bitnami/grafana/logs/

COPY rootfs /
ENV BITNAMI_APP_NAME="grafana" \
    BITNAMI_IMAGE_VERSION="6.4.3-ol-7-r10" \
    PATH="/opt/bitnami/grafana/bin:$PATH"

EXPOSE 3000

WORKDIR /opt/bitnami/grafana
USER 1001
ENTRYPOINT [ "/run.sh" ]
