FROM gcr.io/stacksmith-images/ubuntu:14.04-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=drupal \
    BITNAMI_IMAGE_VERSION=8.1.3-r0 \
    IS_BITNAMI_STACK=1 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/drush:/opt/bitnami/mysql/bin/:$PATH

# Additional modules required
RUN bitnami-pkg install php-5.6.21-0 --checksum 1e0ebe2f26edea96b583d8b7ba2bf895b3c03ea40d67dfb1df3bf331c9caad6c
RUN bitnami-pkg unpack apache-2.4.18-2 --checksum 9722f4f470e036b4ed4f0fe98509e24f7182177b54a268a458af5eb8e7e6370a
RUN bitnami-pkg install libphp-5.6.21-0 --checksum 8c1f994108eb17c69b00ac38617997b8ffad7a145a83848f38361b9571aeb73e
RUN bitnami-pkg install mysql-client-10.1.13-1 --checksum e16c0ace5cb779b486e52af83a56367f26af16a25b4ab92d8f4293f1bf307107

# Install drupal
RUN bitnami-pkg unpack drupal-8.1.3-0 --checksum 42923e5c9b0107ece451740578aaec48994145874d322c97403360c339c3375f

COPY rootfs /

VOLUME ["/bitnami/drupal", "/bitnami/apache"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["harpoon", "start", "--foreground", "apache"]
