FROM gcr.io/stacksmith-images/minideb:jessie-r2

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=kibana \
    BITNAMI_IMAGE_VERSION=5.0.1-r0 \
    PATH=/opt/bitnami/kibana/bin:$PATH

# Install kibana
RUN bitnami-pkg unpack kibana-5.0.1-0 --checksum 61ee20ed33dcde53b8a153390ad137c95e7423e3d38199a4b531f5431cc55823

COPY rootfs /

VOLUME ["/bitnami/kibana"]

EXPOSE 5601

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "kibana"]
