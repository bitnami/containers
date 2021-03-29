FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/kibana/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libgcc1 libstdc++6 procps sudo tar
RUN /build/bitnami-user.sh
RUN /build/install-nami.sh
RUN bitnami-pkg install tini-0.19.0-1 --checksum 9b1f1c095944bac88a62c1b63f3bff1bb123aa7ccd371c908c0e5b41cec2528d
RUN bitnami-pkg unpack kibana-6.8.15-0 --checksum 5c5e46730b4c735a61a94974b50427f4212cd0047ce09f55055480f7666ce162
RUN bitnami-pkg install gosu-1.12.0-2 --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN mkdir -p /bitnami/kibana/ /docker-entrypoint-initdb.d/ && chmod -R g+rwX /bitnami/ /docker-entrypoint-initdb.d/

COPY rootfs /
ENV BITNAMI_APP_NAME="kibana" \
    BITNAMI_IMAGE_VERSION="6.8.15-debian-10-r5" \
    KIBANA_ELASTICSEARCH_PORT_NUMBER="9200" \
    KIBANA_ELASTICSEARCH_URL="elasticsearch" \
    KIBANA_PORT_NUMBER="5601" \
    NAMI_PREFIX="/.nami" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

EXPOSE 5601

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
