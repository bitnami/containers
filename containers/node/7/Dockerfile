FROM bitnami/minideb-extras:jessie-r13-buildpack

MAINTAINER Bitnami <containers@bitnami.com>

# System packages required
RUN install_packages libc6 libssl1.0.0 libncurses5 libtinfo5 zlib1g libbz2-1.0 libreadline6 libstdc++6 libgcc1 ghostscript imagemagick libmysqlclient18

# Install node
RUN bitnami-pkg install node-7.9.0-0 --checksum 8cad1e94040693d46027c401d1ed5bd64f5d4583ff68197483ef3b4512691bf3

COPY rootfs /

ENV PATH=/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH \
    NODE_PATH=/opt/bitnami/node/lib/node_modules

ENV BITNAMI_APP_NAME=node \
    BITNAMI_IMAGE_VERSION=7.9.0-r0

WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["node"]
