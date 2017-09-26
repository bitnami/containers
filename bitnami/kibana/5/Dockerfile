FROM bitnami/minideb-extras:jessie-r22
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN bitnami-pkg unpack kibana-5.6.2-0 --checksum e1eb63ed6b90c0b27b3819d6c670a6146934ffeda04813bbc6f34beda8030f48

COPY rootfs /

ENV BITNAMI_APP_NAME="kibana" \
    BITNAMI_IMAGE_VERSION="5.6.2-r0" \
    KIBANA_ELASTICSEARCH_PORT_NUMBER="9200" \
    KIBANA_ELASTICSEARCH_URL="elasticsearch" \
    KIBANA_PORT_NUMBER="5601" \
    PATH="/opt/bitnami/kibana/bin:$PATH"

EXPOSE 5601

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","kibana"]
