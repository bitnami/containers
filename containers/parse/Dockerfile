FROM gcr.io/stacksmith-images/minideb:jessie-r4

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=parse \
    BITNAMI_IMAGE_VERSION=2.2.24-r1 \
    PATH=/opt/bitnami/node/bin:/opt/bitnami/mongodb/bin:/opt/bitnami/parse/bin:$PATH

# System packages required
RUN install_packages --no-install-recommends libc6 libssl1.0.0 libncurses5 libtinfo5 zlib1g libbz2-1.0 libreadline6 libstdc++6 libgcc1 ghostscript imagemagick libmysqlclient18

# Additional modules required
RUN bitnami-pkg install node-4.6.1-1 --checksum 9deada9ba8f67e81843e874947176cead26dca7e5ae2c7f7007f4479588aa11b
RUN bitnami-pkg install mongodb-client-3.2.11-1 --checksum 948f59fd017a844a5633276f63742ff4013591819b9751b3e070a8805a40c290

# Install parse
RUN bitnami-pkg unpack parse-2.2.24-1 --checksum 40b2d32e38d260ec7fb702862777c1b67dd6f9c5b4fcb18574ce0a50780a6a35

COPY rootfs /

VOLUME ["/bitnami/parse"]

EXPOSE 1337

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "parse"]
