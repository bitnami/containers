FROM gcr.io/stacksmith-images/ubuntu:14.04-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=kibana \
    BITNAMI_IMAGE_VERSION=4.5.4-r1 \
    PATH=/opt/bitnami/kibana/bin:$PATH

# Install kibana
RUN bitnami-pkg unpack kibana-4.5.4-0 --checksum 2b7dca05733dc45e10cf00631459f24149fba10b881646e65473e6046c69a895

COPY rootfs /

VOLUME ["/bitnami/kibana"]

EXPOSE 5601

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "kibana"]
