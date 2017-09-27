FROM bitnami/minideb-extras:jessie-r22-buildpack
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libmysqlclient18 libncurses5 libreadline6 libsqlite3-0 libssl1.0.0 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-8.6.0-0 --checksum 1011c1a84bfbae31cd0adcf5f86e45621ab1373063f98ea90ca1cb7b7ea686a9

COPY rootfs /

ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="8.6.0-r0" \
    NODE_PATH="/opt/bitnami/node/lib/node_modules" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"

EXPOSE 3000

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["node"]
