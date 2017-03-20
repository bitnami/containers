FROM gcr.io/stacksmith-images/minideb-buildpack:jessie-r11

MAINTAINER Bitnami <containers@bitnami.com>

# System packages required
RUN install_packages libc6 libssl1.0.0 libncurses5 libtinfo5 zlib1g libbz2-1.0 libreadline6 libstdc++6 libgcc1 ghostscript imagemagick libmysqlclient18

# Install node
RUN bitnami-pkg unpack node-7.7.3-0 --checksum 73e444ad2294854d46ce4de07a7e0a43647f34288683e73ba58cfc50532578c4

COPY rootfs /

ENV PATH=/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH \
    NODE_PATH=/opt/bitnami/node/lib/node_modules

ENV BITNAMI_APP_NAME=node \
    BITNAMI_IMAGE_VERSION=7.7.3-r0

WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["node"]
