FROM bitnami/oraclelinux-extras:7-r435
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/opt/bitnami/kibana/optimize" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc libgcc libstdc++
RUN bitnami-pkg unpack kibana-6.8.2-0 --checksum c39a3f88065d1d3b6c672a195a5ea24d199236bf64fda774e46f78cbfe03cba2

COPY rootfs /
ENV BITNAMI_APP_NAME="kibana" \
    BITNAMI_IMAGE_VERSION="6.8.2-ol-7-r22" \
    KIBANA_ELASTICSEARCH_PORT_NUMBER="9200" \
    KIBANA_ELASTICSEARCH_URL="elasticsearch" \
    KIBANA_PORT_NUMBER="5601" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/kibana/bin:$PATH"

EXPOSE 5601

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
