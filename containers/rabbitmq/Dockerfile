FROM gcr.io/stacksmith-images/ubuntu:14.04-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=rabbitmq \
    BITNAMI_IMAGE_VERSION=3.6.5-r3 \
    PATH=/opt/bitnami/erlang/bin:/opt/bitnami/rabbitmq/bin:$PATH

# Additional modules required
RUN bitnami-pkg install erlang-17.4-1 --checksum 944246e9367fccd0f92323004a9b9b92ff44d696356890d7ec93c18e759fe021

# Install rabbitmq
RUN bitnami-pkg unpack rabbitmq-3.6.5-1 --checksum e25fca74a7969fc868a6bea311a7c36bc538d15880bbba467434bf892a998879

COPY rootfs /

VOLUME ["/bitnami/rabbitmq"]


EXPOSE 4369 5672 25672 15672

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "rabbitmq"]
