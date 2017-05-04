FROM bitnami/minideb-extras:jessie-r14-buildpack
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="6.10.3-r1" \
    NODE_PATH="/opt/bitnami/node/lib/node_modules" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libmysqlclient18 libncurses5 libreadline6 libsqlite3-0 libssl1.0.0 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-6.10.3-0 --checksum 07bb05274dd2cf71ebdd92ff00925bf1ff16588664e24f59a3b5ecfce7dce238

COPY rootfs /


EXPOSE 3000

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["node"]
