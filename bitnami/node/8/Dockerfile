FROM bitnami/minideb-extras:jessie-r19-buildpack
LABEL maintainer "Bitnami <containers@bitnami.com>"



# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libmysqlclient18 libncurses5 libreadline6 libsqlite3-0 libssl1.0.0 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-8.1.3-0 --checksum def9f116fe48414d959f161f290d4656fa4671594b1cd4c6e193220e4330b02d

COPY rootfs /

ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="8.1.3-r0" \
    NODE_PATH="/opt/bitnami/node/lib/node_modules" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"




EXPOSE 3000

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["node"]
