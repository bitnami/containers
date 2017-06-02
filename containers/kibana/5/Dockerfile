FROM bitnami/minideb-extras:jessie-r16
LABEL maintainer "Bitnami <containers@bitnami.com>"



# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 libstdc++6
RUN bitnami-pkg unpack kibana-5.4.1-0 --checksum c57ffe86c6fc97eb10ea1bad274bbaee2dc4ec664391dc0e11195884d5846df2

COPY rootfs /

ENV BITNAMI_APP_NAME="kibana" \
    BITNAMI_IMAGE_VERSION="5.4.1-r0" \
    KIBANA_ELASTICSEARCH_PORT_NUMBER="9200" \
    KIBANA_ELASTICSEARCH_URL="elasticsearch" \
    KIBANA_PORT_NUMBER="5601" \
    PATH="/opt/bitnami/kibana/bin:$PATH"



VOLUME ["/bitnami/kibana"]

EXPOSE 5601

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","kibana"]
