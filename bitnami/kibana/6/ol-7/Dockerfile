FROM bitnami/oraclelinux-extras:7-r27
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages glibc libX11 libXau libgcc libstdc++ libxcb
RUN bitnami-pkg unpack kibana-6.3.1-0 --checksum 5121e590cc6fc7396128e7bc5ffdce0b7fc8c0912bbed46e8207e75cde0e26d2

COPY rootfs /
ENV BITNAMI_APP_NAME="kibana" \
    BITNAMI_IMAGE_VERSION="6.3.1-ol-7-r1" \
    KIBANA_ELASTICSEARCH_PORT_NUMBER="9200" \
    KIBANA_ELASTICSEARCH_URL="elasticsearch" \
    KIBANA_PORT_NUMBER="5601" \
    PATH="/opt/bitnami/kibana/bin:$PATH"

EXPOSE 5601

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","kibana"]
