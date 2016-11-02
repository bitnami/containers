FROM gcr.io/stacksmith-images/minideb:jessie-r2

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=joomla \
    BITNAMI_IMAGE_VERSION=3.6.4-r1 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin:$PATH

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.23-7 --checksum bcbe93875f4017ed762caf73774a35b449e22c441e6b3f619f386294ba0a5958
RUN bitnami-pkg unpack php-5.6.27-0 --checksum d5b84af990080fb396232558ab70276af4ba85b23ccf8641b6fb11982aa7b83e
RUN bitnami-pkg install libphp-5.6.27-0 --checksum f9039cc69834334187c9b55fc20bf3be818cd87a2088ced2732fead1d1bfb2d6
RUN bitnami-pkg install mysql-client-10.1.18-0 --checksum f2f20e0512e7463996a6ad173156d249aa5ca746a1edb6c46449bd4d2736f725

# Install joomla
RUN bitnami-pkg unpack joomla-3.6.4-0 --checksum d1f19ad50f1b0b1b84848f39b20d81146cf442a890ebd63aa7fc5cdada26a49f

COPY rootfs /

VOLUME ["/bitnami/joomla", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "apache"]
