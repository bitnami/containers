FROM bitnami/minideb-extras:stretch-r189
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libbsd0 libc6 libgcc1 libstdc++6 libx11-6 libxau6 libxcb1 libxdmcp6
RUN bitnami-pkg unpack kibana-6.4.2-2 --checksum 9d168a850d63a5a09af4f7ad54d10acab3028cb8a1ff3c6c7d342b94440fa4b8

COPY rootfs /
ENV BITNAMI_APP_NAME="kibana" \
    BITNAMI_IMAGE_VERSION="6.4.2-debian-9-r13" \
    KIBANA_ELASTICSEARCH_PORT_NUMBER="9200" \
    KIBANA_ELASTICSEARCH_URL="elasticsearch" \
    KIBANA_PORT_NUMBER="5601" \
    PATH="/opt/bitnami/kibana/bin:$PATH"

EXPOSE 5601

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "kibana" ]
