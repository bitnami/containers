FROM gcr.io/stacksmith-images/minideb:jessie-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=ghost \
    BITNAMI_IMAGE_VERSION=0.11.4-r0 \
    PATH=/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:$PATH

# System packages required
RUN install_packages libc6 zlib1g libssl1.0.0 libncurses5 libtinfo5 libstdc++6 libgcc1 libbz2-1.0 libreadline6 ghostscript imagemagick libmysqlclient18

# Additional modules required
RUN bitnami-pkg install mysql-client-10.1.20-0 --checksum 14d20929072b157b5e819deb440504ad0f33f583493b5adeb283c329ea58d513
RUN bitnami-pkg install node-4.7.2-0 --checksum b814eaeeee872c8629432d3e950570ebc2d3dfcdd0db5b4cf8f763652b1981f1

# Install ghost
RUN bitnami-pkg unpack ghost-0.11.4-0 --checksum 0094a80415a6a58d31fdbf2e8698099e7a4d813fa4070d474e3c30113ffbad9d

COPY rootfs /

VOLUME ["/bitnami/ghost"]

EXPOSE 2368

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "ghost"]
