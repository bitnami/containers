FROM bitnami/oraclelinux-extras:7-r567
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/opt/bitnami/kibana/optimize" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc libgcc libstdc++
RUN bitnami-pkg unpack kibana-7.5.0-0 --checksum 28b1c8aeb34bf60727af564b16d194ecf34e6d7fa0df445d9cf1378ff6114e3a
RUN mkdir -p /bitnami/kibana/ /docker-entrypoint-initdb.d/ && chmod -R g+rwX /bitnami/ /docker-entrypoint-initdb.d/

COPY rootfs /
ENV BITNAMI_APP_NAME="kibana" \
    BITNAMI_IMAGE_VERSION="7.5.0-ol-7-r16" \
    KIBANA_ELASTICSEARCH_PORT_NUMBER="9200" \
    KIBANA_ELASTICSEARCH_URL="elasticsearch" \
    KIBANA_PORT_NUMBER="5601" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/kibana/bin:$PATH"

EXPOSE 5601

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
