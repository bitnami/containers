FROM bitnami/minideb-extras:stretch-r96
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 libstdc++6
RUN bitnami-pkg unpack kibana-5.6.10-0 --checksum 75d8f9746eb842d1532424921014cb5ec7e75a3c0c1fd444796114afbd4a9a0a

COPY rootfs /
ENV BITNAMI_APP_NAME="kibana" \
    BITNAMI_IMAGE_VERSION="5.6.10-debian-9-r26" \
    KIBANA_ELASTICSEARCH_PORT_NUMBER="9200" \
    KIBANA_ELASTICSEARCH_URL="elasticsearch" \
    KIBANA_PORT_NUMBER="5601" \
    PATH="/opt/bitnami/kibana/bin:$PATH"

EXPOSE 5601

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","kibana"]
