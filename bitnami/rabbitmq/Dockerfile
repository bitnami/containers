FROM gcr.io/stacksmith-images/ubuntu:14.04-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=rabbitmq \
    BITNAMI_IMAGE_VERSION=3.6.5-r2 \
    PATH=/opt/bitnami/erlang/bin:/opt/bitnami/rabbitmq/bin:$PATH

# Additional modules required
RUN bitnami-pkg install erlang-17.4-0 --checksum 6ab6350a6b56af1f6fe60782ddbb287b5e69ed0ac774d52838fd9620f77cb5ec

# Install rabbitmq
RUN bitnami-pkg unpack rabbitmq-3.6.5-0 --checksum 25a88b34dcb2b03169ee9b6562b93ae88c3921c44a7dac3fc79d9fe6114fdfa9

COPY rootfs /

VOLUME ["/bitnami/rabbitmq"]


EXPOSE 4369 5672 25672 15672

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "rabbitmq"]
