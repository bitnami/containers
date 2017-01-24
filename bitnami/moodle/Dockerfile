FROM gcr.io/stacksmith-images/minideb:jessie-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=moodle \
    BITNAMI_IMAGE_VERSION=3.1.2-r4 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.25-0 --checksum 8b46af7d737772d7d301da8b30a2770b7e549674e33b8a5b07480f53c39f5c3f
RUN bitnami-pkg install mysql-client-10.1.21-0 --checksum 8e868a3e46bfa59f3fb4e1aae22fd9a95fd656c020614a64706106ba2eba224e
RUN bitnami-pkg unpack php-7.1.1-1 --checksum cc64828e801996f2f84d48814d8f74687ffbb0bb15f078586b2bf0a50371c7a9
RUN bitnami-pkg install libphp-7.1.1-0 --checksum 44dcbd3692c4de97638bb8830619f3dbb555e59686804393cd0f2c6038fdcd31

# Install moodle
RUN bitnami-pkg unpack moodle-3.1.2-2 --checksum c4737fd9855611fccf53950b9152820a4e44264d8479d1c75fcbb58cc84b1ed7

COPY rootfs /

VOLUME ["/bitnami/moodle", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "apache"]
