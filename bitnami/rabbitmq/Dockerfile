FROM gcr.io/stacksmith-images/ubuntu:14.04-r07

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=rabbitmq \
    BITNAMI_IMAGE_VERSION=3.6.2-r0 \
    PATH=/opt/bitnami/erlang/bin:/opt/bitnami/rabbitmq/bin:$PATH

# Additional modules required
RUN bitnami-pkg install erlang-17.4-0 --checksum 6ab6350a6b56af1f6fe60782ddbb287b5e69ed0ac774d52838fd9620f77cb5ec

# Install rabbitmq
RUN bitnami-pkg unpack rabbitmq-3.6.3-0 --checksum 7ef3428824b357cb7a1b4338d7b8a373c3da71835ad3fd50d2f08d628906e591

COPY rootfs /

VOLUME ["/bitnami/rabbitmq"]

EXPOSE 15672

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["harpoon", "start", "--foreground", "rabbitmq"]
