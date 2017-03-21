FROM gcr.io/bitnami-containers/minideb-extras:jessie-r12

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=kibana \
    BITNAMI_IMAGE_VERSION=5.2.2-r2 \
    PATH=/opt/bitnami/kibana/bin:$PATH

# System packages required
RUN install_packages libc6 libstdc++6 libgcc1

# Install kibana
RUN bitnami-pkg unpack kibana-5.2.2-0 --checksum 56681f7c24890e82bbc580fcf24c8eac2c64d0efddd4fd01c21c4113cb87fd45

COPY rootfs /

ENV KIBANA_PORT="5601" \
    KIBANA_ELASTICSEARCH_URL="elasticsearch" \
    KIBANA_ELASTICSEARCH_PORT="9200"

VOLUME ["/bitnami/kibana"]

EXPOSE 5601

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "kibana"]
