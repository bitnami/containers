FROM gcr.io/stacksmith-images/ubuntu:14.04-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=ghost \
    BITNAMI_IMAGE_VERSION=0.7.9-r0 \
    PATH=/opt/bitnami/node/bin:$PATH

# Additional modules required
RUN bitnami-pkg install node-4.4.5-1 --checksum 650b85fb3f78ee0662be107b582c17ddaaa0ff694fe9f1ce8752eae13c2881bc

# Install ghost
RUN bitnami-pkg unpack ghost-0.7.9-0 --checksum 1f48608b94720f7b4227df10a7ecbdfadd3bc1d1367ac5f8b6c999cd4c6d0b96

COPY rootfs /

VOLUME ["/bitnami/ghost"]

EXPOSE 2368

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["harpoon", "start", "--foreground", "ghost"]
