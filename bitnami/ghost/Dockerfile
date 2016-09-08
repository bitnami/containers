FROM gcr.io/stacksmith-images/ubuntu:14.04-r9

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=ghost \
    BITNAMI_IMAGE_VERSION=0.10.1-r0 \
    PATH=/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:$PATH

# Additional modules required
RUN bitnami-pkg install node-4.5.0-0 --checksum af047acbfe0c0f918536de0dfa690178808d2e5fc07dfa7acc34c77f0a60fd55
RUN bitnami-pkg install mysql-client-10.1.13-4 --checksum 14b45c91dd78b37f0f2366712cbe9bfdf2cb674769435611955191a65dbf4976

# Install ghost
RUN bitnami-pkg unpack ghost-0.10.1-0 --checksum baaa2181f7b5f5b1dcabd012a1891ada12a3d647ebeaaaf435cb843c6a2bdb19

COPY rootfs /

VOLUME ["/bitnami/ghost"]

EXPOSE 2368

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "ghost"]
