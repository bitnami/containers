FROM bitnami/minideb-extras:jessie-r22
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN bitnami-pkg unpack kibana-5.6.4-0 --checksum 2da7b30a7a7f4707f853cf640943fa8da3ddffbb4d3f17bb81786c7f960fdfaa

COPY rootfs /

ENV BITNAMI_APP_NAME="kibana" \
    BITNAMI_IMAGE_VERSION="5.6.4-r0" \
    KIBANA_ELASTICSEARCH_PORT_NUMBER="9200" \
    KIBANA_ELASTICSEARCH_URL="elasticsearch" \
    KIBANA_PORT_NUMBER="5601" \
    PATH="/opt/bitnami/kibana/bin:$PATH"

EXPOSE 5601

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","kibana"]
