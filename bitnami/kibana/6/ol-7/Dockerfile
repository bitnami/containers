FROM bitnami/oraclelinux-extras:7-r20
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages glibc libX11 libXau libgcc libstdc++ libxcb
RUN bitnami-pkg unpack kibana-6.2.4-0 --checksum 3b7b73a270e51c9887020a1d8833e0b3faf60587af139cbfb3d7ef5fa4057410

COPY rootfs /
ENV BITNAMI_APP_NAME="kibana" \
    BITNAMI_IMAGE_VERSION="6.2.4-ol-7-r6" \
    KIBANA_ELASTICSEARCH_PORT_NUMBER="9200" \
    KIBANA_ELASTICSEARCH_URL="elasticsearch" \
    KIBANA_PORT_NUMBER="5601" \
    PATH="/opt/bitnami/kibana/bin:$PATH"

EXPOSE 5601

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","kibana"]
