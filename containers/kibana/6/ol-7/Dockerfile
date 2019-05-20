FROM bitnami/oraclelinux-extras:7-r342
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/opt/bitnami/kibana/optimize" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc libgcc libstdc++
RUN bitnami-pkg unpack kibana-6.8.0-0 --checksum 718a1915b6382312d75e1710999ed8c3214db995b2d9fab28e6b353c443c01fd

COPY rootfs /
ENV BITNAMI_APP_NAME="kibana" \
    BITNAMI_IMAGE_VERSION="6.8.0-ol-7-r0" \
    KIBANA_ELASTICSEARCH_PORT_NUMBER="9200" \
    KIBANA_ELASTICSEARCH_URL="elasticsearch" \
    KIBANA_PORT_NUMBER="5601" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/kibana/bin:$PATH"

EXPOSE 5601

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
