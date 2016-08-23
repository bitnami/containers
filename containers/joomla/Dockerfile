FROM gcr.io/stacksmith-images/ubuntu:14.04-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=joomla \
    BITNAMI_IMAGE_VERSION=3.6.0-r1 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.23-0 --checksum 90b395bdb707cdbfc7786d79c4c064cade1135f94ff7f973d359c28c5ee8cebf
RUN bitnami-pkg unpack php-5.6.24-0 --checksum bd4d033027f86efe21d743e66273dea113efb5d9d6eb778bf12a004719736928
RUN bitnami-pkg install libphp-5.6.21-0 --checksum 8c1f994108eb17c69b00ac38617997b8ffad7a145a83848f38361b9571aeb73e
RUN bitnami-pkg install mysql-client-10.1.13-1 --checksum e16c0ace5cb779b486e52af83a56367f26af16a25b4ab92d8f4293f1bf307107

# Install joomla
RUN bitnami-pkg unpack joomla-3.6.0-0 --checksum dc7ed4fbd9df94ee59587072fe4a44bd2c253a1982b3b8c48ea2e781469f4a67

COPY rootfs /

VOLUME ["/bitnami/joomla", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["harpoon", "start", "--foreground", "apache"]
