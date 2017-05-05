FROM bitnami/minideb-extras:jessie-r15

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=kibana \
    BITNAMI_IMAGE_VERSION=5.3.1-r1 \
    PATH=/opt/bitnami/kibana/bin:$PATH

# System packages required
RUN install_packages libc6 libstdc++6 libgcc1

# Install kibana
RUN bitnami-pkg unpack kibana-5.3.1-0 --checksum 3f22493f8636bc7b4161d60d02f0c2879423a1198446a438425d59013f6bb9bd

COPY rootfs /

ENV KIBANA_PORT="5601" \
    KIBANA_ELASTICSEARCH_URL="elasticsearch" \
    KIBANA_ELASTICSEARCH_PORT="9200"

VOLUME ["/bitnami/kibana"]

EXPOSE 5601

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "kibana"]
