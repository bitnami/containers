FROM gcr.io/stacksmith-images/minideb:jessie-r2

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=orangehrm \
    BITNAMI_IMAGE_VERSION=3.3.3 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# Additional modules required
RUN bitnami-pkg install apache-2.4.23-9 --checksum 25bf5b82662874c21b0c0614c057d06b4a8ec14d8a76181053b691a9dfbf7f94
RUN bitnami-pkg install mysql-client-10.1.18-0 --checksum f2f20e0512e7463996a6ad173156d249aa5ca746a1edb6c46449bd4d2736f725
RUN bitnami-pkg install php-5.6.27-2 --checksum 84d7fe4036a4218afd79b006c9fad55eab3cfec7a47d3a86183805f863813001
RUN bitnami-pkg install libphp-5.6.27-0 --checksum f9039cc69834334187c9b55fc20bf3be818cd87a2088ced2732fead1d1bfb2d6

# Install orangehrm
RUN bitnami-pkg unpack orangehrm-3.3.3-0 --checksum c4ed5a3b5b5bb48422a88a2e6b1ae899eda3917530cef595287c12072f400dfa

COPY rootfs /

VOLUME ["/bitnami/orangehrm", "/bitnami/apache"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "apache"]
