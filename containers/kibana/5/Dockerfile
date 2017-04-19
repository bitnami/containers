FROM bitnami/minideb-extras:jessie-r13

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=kibana \
    BITNAMI_IMAGE_VERSION=5.3.0-r0 \
    PATH=/opt/bitnami/kibana/bin:$PATH

# System packages required
RUN install_packages libc6 libstdc++6 libgcc1

# Install kibana
RUN bitnami-pkg unpack kibana-5.3.0-0 --checksum 4bbeccf6e8c13f66c91f6d80c19a3fa566f2604d5cd11093f8fba413f96bb1c9

COPY rootfs /

ENV KIBANA_PORT="5601" \
    KIBANA_ELASTICSEARCH_URL="elasticsearch" \
    KIBANA_ELASTICSEARCH_PORT="9200"

VOLUME ["/bitnami/kibana"]

EXPOSE 5601

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "kibana"]
