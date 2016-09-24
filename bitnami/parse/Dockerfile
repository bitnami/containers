FROM gcr.io/stacksmith-images/ubuntu:14.04-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=parse \
    BITNAMI_IMAGE_VERSION=2.2.18-r2 \
    PATH=/opt/bitnami/node/bin:/opt/bitnami/mongodb/bin:/opt/bitnami/parse/bin:$PATH

# Additional modules required
RUN bitnami-pkg install node-4.5.0-1 --checksum 4ea3d270ea4b44f53d628357a062066438248a49331a0b9e4eb5e6b3671d076f
RUN bitnami-pkg install mongodb-client-3.2.7-4 --checksum 251b952828fa1dfaae4063914bba46ea8a1aaf9c0954850c00ee772000077f8d

# Install parse
RUN bitnami-pkg unpack parse-2.2.18-0 --checksum 03939b9b68d1555bea5e648db34dc5e45f6ea1dd25cc8a6b989a493cc9b294b9

COPY rootfs /

VOLUME ["/bitnami/parse"]

EXPOSE 1337

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "parse"]
