FROM gcr.io/stacksmith-images/ubuntu:14.04-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=drupal \
    BITNAMI_IMAGE_VERSION=8.1.10-r0 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/drush:/opt/bitnami/mysql/bin/:$PATH

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.23-7 --checksum bcbe93875f4017ed762caf73774a35b449e22c441e6b3f619f386294ba0a5958
RUN bitnami-pkg unpack php-5.6.26-1 --checksum b7a72ae78f9b19352bd400dfe027465c88a8643c0e5d9753f8d12f4ebae542a2
RUN bitnami-pkg install libphp-5.6.26-1 --checksum 327d070f57727f2ed4f0246d0e3f61c5a94f6366d21a7e7e4572fe6c9c8e8c2d
RUN bitnami-pkg install mysql-client-10.1.13-4 --checksum 14b45c91dd78b37f0f2366712cbe9bfdf2cb674769435611955191a65dbf4976

# Install drupal
RUN bitnami-pkg unpack drupal-8.1.10-0 --checksum c6bb4729d078998e7358bf098036a4baa415c777b34e1e08cca4ccdcac6edb9a

COPY rootfs /

VOLUME ["/bitnami/drupal", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "apache"]
