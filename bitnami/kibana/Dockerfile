FROM gcr.io/stacksmith-images/minideb:jessie-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=kibana \
    BITNAMI_IMAGE_VERSION=4.6.1-r4 \
    PATH=/opt/bitnami/kibana/bin:$PATH

# System packages required
RUN install_packages --no-install-recommends libc6 libstdc++6 libgcc1

# Install kibana
RUN bitnami-pkg unpack kibana-4.6.1-1 --checksum 85490bde3f99b8fddf51a70bc028bf966780723e90a093d5c46911510e32b26c

COPY rootfs /

VOLUME ["/bitnami/kibana"]

EXPOSE 5601

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "kibana"]
