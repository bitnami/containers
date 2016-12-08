FROM gcr.io/stacksmith-images/minideb:jessie-r5

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=ghost \
    BITNAMI_IMAGE_VERSION=0.11.3-r2 \
    PATH=/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:$PATH

# System packages required
RUN install_packages libc6 zlib1g libssl1.0.0 libncurses5 libtinfo5 libstdc++6 libgcc1 libbz2-1.0 libreadline6 ghostscript imagemagick libmysqlclient18

# Additional modules required
RUN bitnami-pkg install mysql-client-10.1.19-1 --checksum 2d946c8ee3e2e845f68a5cf3751d6477d88af194d263842797fe50a44414a173
RUN bitnami-pkg install node-4.6.1-1 --checksum 9deada9ba8f67e81843e874947176cead26dca7e5ae2c7f7007f4479588aa11b

# Install ghost
RUN bitnami-pkg unpack ghost-0.11.3-1 --checksum 23f1be9c59700eba8343be455c5e78a2b00b5f11982aab5e68e12899cfb0cebf

COPY rootfs /

VOLUME ["/bitnami/ghost"]

EXPOSE 2368

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "ghost"]
