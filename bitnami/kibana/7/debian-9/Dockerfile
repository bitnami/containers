FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/opt/bitnami/kibana/optimize" \
    HOME="/" \
    PATH="/opt/bitnami/kibana/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl dirmngr gnupg libc6 libgcc1 libstdc++6 procps sudo unzip
RUN /build/bitnami-user.sh && \
    /build/install-nami.sh
RUN bitnami-pkg unpack kibana-7.5.2-0 --checksum 871b28e19c93e938e11ed631e59ec14ddfa35ddd3360c7eeb16e2993da103e4d
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/install-gosu.sh
RUN mkdir -p /bitnami/kibana/ /docker-entrypoint-initdb.d/ && chmod -R g+rwX /bitnami/ /docker-entrypoint-initdb.d/
RUN /build/install-tini.sh

COPY rootfs /
ENV BITNAMI_APP_NAME="kibana" \
    BITNAMI_IMAGE_VERSION="7.5.2-debian-9-r0" \
    KIBANA_ELASTICSEARCH_PORT_NUMBER="9200" \
    KIBANA_ELASTICSEARCH_URL="elasticsearch" \
    KIBANA_PORT_NUMBER="5601" \
    NAMI_PREFIX="/.nami"

EXPOSE 5601

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
