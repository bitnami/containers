FROM gcr.io/stacksmith-images/minideb-buildpack:jessie-r11

MAINTAINER Bitnami <containers@bitnami.com>

# System packages required
RUN install_packages libc6 libssl1.0.0 libncurses5 libtinfo5 zlib1g libbz2-1.0 libreadline6 libstdc++6 libgcc1 ghostscript imagemagick libmysqlclient18

# Install node
RUN bitnami-pkg unpack node-7.7.2-0 --checksum ba9283f31f5cd92f9ef7e21c1caf5a886dca0d4a7c20ae2e2eb9c620e62a503c

COPY rootfs /

ENV PATH=/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH \
    NODE_PATH=/opt/bitnami/node/lib/node_modules

ENV BITNAMI_APP_NAME=node \
    BITNAMI_IMAGE_VERSION=7.7.2-r0

WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["node"]
