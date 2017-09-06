FROM bitnami/minideb-extras:jessie-r22-buildpack
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libmysqlclient18 libncurses5 libreadline6 libsqlite3-0 libssl1.0.0 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-6.11.3-0 --checksum 44d840c83cd9b3a09ecef5238b261372441d1803cf73b6c5ac5689a96d33db8b

COPY rootfs /

ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="6.11.3-r0" \
    NODE_PATH="/opt/bitnami/node/lib/node_modules" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"

EXPOSE 3000

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["node"]
