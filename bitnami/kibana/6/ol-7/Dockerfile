FROM bitnami/oraclelinux-extras:7-r586
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/opt/bitnami/kibana/optimize" \
    HOME="/"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages glibc libgcc libstdc++
RUN bitnami-pkg unpack kibana-6.8.6-0 --checksum bfc2a79de6f7185537cedb38ddcd8eef942afd3b4fe97a4e8763b834029e67a6
RUN mkdir -p /bitnami/kibana/ /docker-entrypoint-initdb.d/ && chmod -R g+rwX /bitnami/ /docker-entrypoint-initdb.d/

COPY rootfs /
ENV BITNAMI_APP_NAME="kibana" \
    BITNAMI_IMAGE_VERSION="6.8.6-ol-7-r19" \
    KIBANA_ELASTICSEARCH_PORT_NUMBER="9200" \
    KIBANA_ELASTICSEARCH_URL="elasticsearch" \
    KIBANA_PORT_NUMBER="5601" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/kibana/bin:$PATH"

EXPOSE 5601

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
