FROM bitnami/minideb-extras:jessie-r22
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN bitnami-pkg unpack kibana-6.0.1-0 --checksum e699466df63b1b6b9fde30577c5ac58b6c7b9edfc277e23bc71069d9aff0774e

COPY rootfs /

ENV BITNAMI_APP_NAME="kibana" \
    BITNAMI_IMAGE_VERSION="6.0.1-r0" \
    KIBANA_ELASTICSEARCH_PORT_NUMBER="9200" \
    KIBANA_ELASTICSEARCH_URL="elasticsearch" \
    KIBANA_PORT_NUMBER="5601" \
    PATH="/opt/bitnami/kibana/bin:$PATH"

EXPOSE 5601

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","kibana"]
