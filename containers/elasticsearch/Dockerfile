FROM gcr.io/stacksmith-images/minideb:jessie-r5

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=elasticsearch \
    BITNAMI_IMAGE_VERSION=2.4.1-r2 \
    PATH=/opt/bitnami/java/bin:/opt/bitnami/elasticsearch/bin:$PATH

# System packages required
RUN install_packages --no-install-recommends libc6 libxext6 libx11-6 libxcb1 libxau6 libxdmcp6 libglib2.0-0 libfreetype6 libfontconfig1 libstdc++6 libgcc1 zlib1g libselinux1 libpng12-0 libexpat1 libffi6 libpcre3 libxml2 liblzma5

# Additional modules required
RUN bitnami-pkg install java-1.8.0_111-1 --checksum f7705a3955f006eb59a6e4240a01d8273b17ba38428d30ffe7d10c9cc525d7be

# Install elasticsearch
RUN bitnami-pkg unpack elasticsearch-2.4.1-1 --checksum c7be1a4ee64c329922a9a7800379b855a699e685eb1ecd874eee8ba8d414b2a2

COPY rootfs /

VOLUME ["/bitnami/elasticsearch"]

EXPOSE 9200 9300

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "elasticsearch"]
