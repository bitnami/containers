FROM gcr.io/stacksmith-images/minideb:jessie-r2

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=rabbitmq \
    BITNAMI_IMAGE_VERSION=3.6.6-r0 \
    PATH=/opt/bitnami/erlang/bin:/opt/bitnami/rabbitmq/bin:$PATH

# Additional modules required
RUN bitnami-pkg install erlang-17.4-1 --checksum 944246e9367fccd0f92323004a9b9b92ff44d696356890d7ec93c18e759fe021

# Install rabbitmq
RUN bitnami-pkg unpack rabbitmq-3.6.6-0 --checksum 69b06c16b313903fe09cd4848c47ab1356f90c195556f2a6d69e5201a8b809ed

COPY rootfs /

VOLUME ["/bitnami/rabbitmq"]


EXPOSE 4369 5672 25672 15672

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "rabbitmq"]
