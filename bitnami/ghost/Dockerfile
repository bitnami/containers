FROM gcr.io/stacksmith-images/ubuntu:14.04-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=ghost \
    BITNAMI_IMAGE_VERSION=0.7.9-r2 \
    PATH=/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:$PATH

# Additional modules required
RUN bitnami-pkg install node-4.4.5-1 --checksum 650b85fb3f78ee0662be107b582c17ddaaa0ff694fe9f1ce8752eae13c2881bc
RUN bitnami-pkg install mysql-client-10.1.13-4 --checksum 14b45c91dd78b37f0f2366712cbe9bfdf2cb674769435611955191a65dbf4976

# Install ghost
RUN bitnami-pkg unpack ghost-0.7.9-2 --checksum 43895a7ed0489f8dc59c6b0b7111ad56ed7ea9aa95c073bc405a3f5c3d843189

COPY rootfs /

VOLUME ["/bitnami/ghost"]

EXPOSE 2368

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["harpoon", "start", "--foreground", "ghost"]
