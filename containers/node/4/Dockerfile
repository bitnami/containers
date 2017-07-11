FROM bitnami/minideb-extras:jessie-r19-buildpack
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libmysqlclient18 libncurses5 libreadline6 libsqlite3-0 libssl1.0.0 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-4.8.4-0 --checksum 8efa0e5d8089757e5849c81b3245e9268d84bbafbd3444e00e011f6fbe88d85e

COPY rootfs /

ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="4.8.4-r0" \
    NODE_PATH="/opt/bitnami/node/lib/node_modules" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"

EXPOSE 3000

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["node"]
