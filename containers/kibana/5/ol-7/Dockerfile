FROM bitnami/oraclelinux-extras:7-r155
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages glibc libgcc libstdc++
RUN bitnami-pkg unpack kibana-5.6.12-1 --checksum 07f3a8297dc01a74d17dabbed19dd6fe71c852d1d71223e53a267f1ff005e54c

COPY rootfs /
ENV BITNAMI_APP_NAME="kibana" \
    BITNAMI_IMAGE_VERSION="5.6.12-ol-7-r44" \
    KIBANA_ELASTICSEARCH_PORT_NUMBER="9200" \
    KIBANA_ELASTICSEARCH_URL="elasticsearch" \
    KIBANA_PORT_NUMBER="5601" \
    PATH="/opt/bitnami/kibana/bin:$PATH"

EXPOSE 5601

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "kibana" ]
