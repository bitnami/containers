FROM gcr.io/stacksmith-images/minideb:jessie-r2

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=rabbitmq \
    BITNAMI_IMAGE_VERSION=3.6.6-r2 \
    PATH=/opt/bitnami/erlang/bin:/opt/bitnami/rabbitmq/bin:$PATH

# Additional modules required
RUN bitnami-pkg install erlang-17.4-2 --checksum 75a0f0dd2c3e58271c8fa8308404f82cbe14925aa6b737da90b8641adef2a717

# Install rabbitmq
RUN bitnami-pkg unpack rabbitmq-3.6.6-1 --checksum 0b035f73488cdae9cfd2f7b3e8fd6d64c0722732866c9fe020c1d07dd3ba88a6

COPY rootfs /

VOLUME ["/bitnami/rabbitmq"]


EXPOSE 4369 5672 25672 15672

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "rabbitmq"]
