FROM gcr.io/stacksmith-images/minideb:jessie-r2

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=ghost \
    BITNAMI_IMAGE_VERSION=0.11.3-r0 \
    PATH=/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:$PATH

# Additional modules required
RUN bitnami-pkg install mysql-client-10.1.18-0 --checksum f2f20e0512e7463996a6ad173156d249aa5ca746a1edb6c46449bd4d2736f725
RUN bitnami-pkg install node-4.6.1-0 --checksum 3eb5e4639c18b8ac19f0c7a54cc5874a738853300fd91500642f748334dd1693

# Install ghost
RUN bitnami-pkg unpack ghost-0.11.3-0 --checksum 6689faddafb7e93ff101e571f95f905c35a46c0b9d430fe0a10c63a22b404f06

COPY rootfs /

VOLUME ["/bitnami/ghost"]

EXPOSE 2368

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "ghost"]
