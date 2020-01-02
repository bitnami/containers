FROM bitnami/oraclelinux-extras:7-r582
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/opt/bitnami/kibana/optimize" \
    HOME="/"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages glibc libgcc libstdc++
RUN bitnami-pkg unpack kibana-7.5.1-0 --checksum 88e0201898d3b80dde5079fec8c0bbc66d81e31a655e35eb942b6912c28dac8b
RUN mkdir -p /bitnami/kibana/ /docker-entrypoint-initdb.d/ && chmod -R g+rwX /bitnami/ /docker-entrypoint-initdb.d/

COPY rootfs /
ENV BITNAMI_APP_NAME="kibana" \
    BITNAMI_IMAGE_VERSION="7.5.1-ol-7-r15" \
    KIBANA_ELASTICSEARCH_PORT_NUMBER="9200" \
    KIBANA_ELASTICSEARCH_URL="elasticsearch" \
    KIBANA_PORT_NUMBER="5601" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/kibana/bin:$PATH"

EXPOSE 5601

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
