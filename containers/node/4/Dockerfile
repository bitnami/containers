FROM bitnami/minideb-extras:jessie-r14-buildpack
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="4.8.3-r1" \
    NODE_PATH="/opt/bitnami/node/lib/node_modules" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libmysqlclient18 libncurses5 libreadline6 libsqlite3-0 libssl1.0.0 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-4.8.3-0 --checksum 82ac604d6b97bd2070c8ff613de802096e5addd644d6817745ca2aa71d689aa3

COPY rootfs /


EXPOSE 3000

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["node"]
