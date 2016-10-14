FROM gcr.io/stacksmith-images/ubuntu:14.04-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=kibana \
    BITNAMI_IMAGE_VERSION=4.6.1-r0 \
    PATH=/opt/bitnami/kibana/bin:$PATH

# Install kibana
RUN bitnami-pkg unpack kibana-4.6.1-0 --checksum 665e7c0b55eea86af15d51d8eb2b9f06fd4eef5c2f1c63b74107b3853cb4765d

COPY rootfs /

VOLUME ["/bitnami/kibana"]

EXPOSE 5601

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "kibana"]
