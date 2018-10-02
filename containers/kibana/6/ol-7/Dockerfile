FROM bitnami/oraclelinux-extras:7-r124
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages glibc libX11 libXau libgcc libstdc++ libxcb
RUN bitnami-pkg unpack kibana-6.4.0-0 --checksum bf914cc7b8155ffe037e23d2b23e02b01b3710c8db16bec53d89ab5c144fbd60

COPY rootfs /
ENV BITNAMI_APP_NAME="kibana" \
    BITNAMI_IMAGE_VERSION="6.4.0-ol-7-r0" \
    KIBANA_ELASTICSEARCH_PORT_NUMBER="9200" \
    KIBANA_ELASTICSEARCH_URL="elasticsearch" \
    KIBANA_PORT_NUMBER="5601" \
    PATH="/opt/bitnami/kibana/bin:$PATH"

EXPOSE 5601

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "kibana" ]
