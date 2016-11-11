FROM gcr.io/stacksmith-images/minideb:jessie-r2

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=moodle \
    BITNAMI_IMAGE_VERSION=3.1.2-r3 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.23-9 --checksum 25bf5b82662874c21b0c0614c057d06b4a8ec14d8a76181053b691a9dfbf7f94
RUN bitnami-pkg unpack php-5.6.27-2 --checksum 84d7fe4036a4218afd79b006c9fad55eab3cfec7a47d3a86183805f863813001
RUN bitnami-pkg install libphp-5.6.27-0 --checksum f9039cc69834334187c9b55fc20bf3be818cd87a2088ced2732fead1d1bfb2d6
RUN bitnami-pkg install mysql-client-10.1.19-0 --checksum fdbc292bedabeaf0148d66770b8aa0ab88012ce67b459d6ba2b46446c91bb79c

# Install moodle
RUN bitnami-pkg unpack moodle-3.1.2-2 --checksum c4737fd9855611fccf53950b9152820a4e44264d8479d1c75fcbb58cc84b1ed7

COPY rootfs /

VOLUME ["/bitnami/moodle", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "apache"]
