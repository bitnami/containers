FROM bitnami/minideb-extras:jessie-r82
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 libstdc++6 libx11-6 libxau6 libxcb1 libxdmcp6
RUN bitnami-pkg unpack kibana-6.2.4-0 --checksum 5913503149444c065dec8bae1f5d618399ca20d883fc088971d2a7c9efb1a3aa

COPY rootfs /
ENV BITNAMI_APP_NAME="kibana" \
    BITNAMI_IMAGE_VERSION="6.2.4-r23" \
    KIBANA_ELASTICSEARCH_PORT_NUMBER="9200" \
    KIBANA_ELASTICSEARCH_URL="elasticsearch" \
    KIBANA_PORT_NUMBER="5601" \
    PATH="/opt/bitnami/kibana/bin:$PATH"

EXPOSE 5601

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","kibana"]
