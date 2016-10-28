FROM gcr.io/stacksmith-images/minideb:jessie-r2

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=ghost \
    BITNAMI_IMAGE_VERSION=0.11.0-r1 \
    PATH=/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:$PATH

# Additional modules required
RUN bitnami-pkg install mysql-client-10.1.13-4 --checksum 14b45c91dd78b37f0f2366712cbe9bfdf2cb674769435611955191a65dbf4976
RUN bitnami-pkg install node-4.6.0-0 --checksum 92c3e691acb92cefb619d7ca501e50cf3c5148ba4121aaed3bc21951a386fb4f

# Install ghost
RUN bitnami-pkg unpack ghost-0.11.2-0 --checksum a5d054f0774694a8f2ff697f8d9b9b36ae29f1c4ef3f1f9709db50a3a817126c

COPY rootfs /

VOLUME ["/bitnami/ghost"]

EXPOSE 2368

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "ghost"]
