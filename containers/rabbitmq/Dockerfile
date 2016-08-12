FROM gcr.io/stacksmith-images/ubuntu:14.04-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=rabbitmq \
    BITNAMI_IMAGE_VERSION=3.6.4-r0 \
    PATH=/opt/bitnami/erlang/bin:/opt/bitnami/rabbitmq/bin:$PATH

# Additional modules required
RUN bitnami-pkg install erlang-17.4-0 --checksum 6ab6350a6b56af1f6fe60782ddbb287b5e69ed0ac774d52838fd9620f77cb5ec

# Install rabbitmq
RUN bitnami-pkg unpack rabbitmq-3.6.4-0 --checksum 817bc6a0e981a8b1d056c1a36d59c90b906eac0e883f8a20b46e46d3b35642be

COPY rootfs /

VOLUME ["/bitnami/rabbitmq"]

EXPOSE 15672

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["harpoon", "start", "--foreground", "rabbitmq"]
