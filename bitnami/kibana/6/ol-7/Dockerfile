FROM bitnami/oraclelinux-extras:7-r20
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages glibc libX11 libXau libgcc libstdc++ libxcb
RUN bitnami-pkg unpack kibana-6.3.0-0 --checksum b03142905874f7fc0c72ebc39dedfca4812e422eb93fe30a10e8536f0efa086b

COPY rootfs /
ENV BITNAMI_APP_NAME="kibana" \
    BITNAMI_IMAGE_VERSION="6.3.0-ol-7-r0" \
    KIBANA_ELASTICSEARCH_PORT_NUMBER="9200" \
    KIBANA_ELASTICSEARCH_URL="elasticsearch" \
    KIBANA_PORT_NUMBER="5601" \
    PATH="/opt/bitnami/kibana/bin:$PATH"

EXPOSE 5601

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","kibana"]
