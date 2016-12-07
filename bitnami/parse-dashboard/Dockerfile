FROM gcr.io/stacksmith-images/minideb:jessie-r5

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=parse-dashboard \
    BITNAMI_IMAGE_VERSION=1.0.19-r3 \
    PATH=/opt/bitnami/node/bin:$PATH

# System packages required
RUN install_packages --no-install-recommends libc6 libssl1.0.0 libncurses5 libtinfo5 zlib1g libbz2-1.0 libreadline6 libstdc++6 libgcc1 ghostscript imagemagick libmysqlclient18

# Additional modules required
RUN bitnami-pkg install node-4.6.1-1 --checksum 9deada9ba8f67e81843e874947176cead26dca7e5ae2c7f7007f4479588aa11b

# Install parsedashboard
RUN bitnami-pkg unpack parse-dashboard-1.0.19-2 --checksum f0bc6bb74120325606f02f84db8213a979318e20ebccfe6e5f6898a553db9f0f

COPY rootfs /

VOLUME ["/bitnami/parse-dashboard"]

EXPOSE 4040

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "parse-dashboard"]
