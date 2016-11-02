FROM gcr.io/stacksmith-images/minideb:jessie-r2

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=phpbb \
    BITNAMI_IMAGE_VERSION=3.1.10-r0 \
    PATH=/opt/bitnami/mysql/bin/:/opt/bitnami/php/bin/:$PATH

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.23-8 --checksum 391deed983f7aaa04b4b47af59d8e8ced4f88076eff18d5405d196b6b270433c
RUN bitnami-pkg unpack php-5.6.27-0 --checksum d5b84af990080fb396232558ab70276af4ba85b23ccf8641b6fb11982aa7b83e
RUN bitnami-pkg install libphp-5.6.27-0 --checksum f9039cc69834334187c9b55fc20bf3be818cd87a2088ced2732fead1d1bfb2d6
RUN bitnami-pkg install mysql-client-10.1.18-0 --checksum f2f20e0512e7463996a6ad173156d249aa5ca746a1edb6c46449bd4d2736f725

# Install phpbb
RUN bitnami-pkg unpack phpbb-3.1.10-0 --checksum 5185cce84e5a8a111a98295a09ce705a31ecac2750f9715b7287a977c24bee9b

COPY rootfs /

VOLUME ["/bitnami/phpbb", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "apache"]
