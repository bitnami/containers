FROM bitnami/oraclelinux-extras:7-r156
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages glibc libX11 libXau libgcc libstdc++ libxcb
RUN bitnami-pkg unpack kibana-6.4.2-1 --checksum 5b121f17f6d2859610301d1d2c357e1495045981e9c1c37886e05dd3735d2ce4

COPY rootfs /
ENV BITNAMI_APP_NAME="kibana" \
    BITNAMI_IMAGE_VERSION="6.4.2-ol-7-r15" \
    KIBANA_ELASTICSEARCH_PORT_NUMBER="9200" \
    KIBANA_ELASTICSEARCH_URL="elasticsearch" \
    KIBANA_PORT_NUMBER="5601" \
    PATH="/opt/bitnami/kibana/bin:$PATH"

EXPOSE 5601

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "kibana" ]
