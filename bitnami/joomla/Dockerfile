FROM gcr.io/stacksmith-images/ubuntu:14.04-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=joomla \
    BITNAMI_IMAGE_VERSION=3.6.3-r0 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin:$PATH

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.23-7 --checksum bcbe93875f4017ed762caf73774a35b449e22c441e6b3f619f386294ba0a5958
RUN bitnami-pkg unpack php-5.6.27-0 --checksum d5b84af990080fb396232558ab70276af4ba85b23ccf8641b6fb11982aa7b83e
RUN bitnami-pkg install libphp-5.6.27-0 --checksum f9039cc69834334187c9b55fc20bf3be818cd87a2088ced2732fead1d1bfb2d6
RUN bitnami-pkg install mysql-client-10.1.13-4 --checksum 14b45c91dd78b37f0f2366712cbe9bfdf2cb674769435611955191a65dbf4976

# Install joomla
RUN bitnami-pkg unpack joomla-3.6.3-0 --checksum 7e4a516863b7b1d74e49b31af3bf931efce22efbfc8eee3c8a5c0681a4d6571a

COPY rootfs /

VOLUME ["/bitnami/joomla", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "apache"]
