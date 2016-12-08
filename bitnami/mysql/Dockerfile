FROM gcr.io/stacksmith-images/minideb:jessie-r5

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=5.7.16-r4 \
    BITNAMI_APP_NAME=mysql \
    BITNAMI_APP_USER=mysql \
    PATH=/opt/bitnami/mysql/sbin:/opt/bitnami/mysql/bin:$PATH

# System packages required
RUN install_packages --no-install-recommends libc6 libstdc++6 libgcc1 libncurses5 libtinfo5 zlib1g libssl1.0.0 libaio1

# Install mysql
RUN bitnami-pkg unpack mysql-5.7.16-3 --checksum d87883515b0198fddf3adbc9b295beedf2802fa2fa5ec51eae1f972e736f20b8

COPY rootfs /

VOLUME ["/bitnami/mysql"]

EXPOSE 3306

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "mysql"]
