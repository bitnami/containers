FROM gcr.io/stacksmith-images/minideb:jessie-r2

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=drupal \
    BITNAMI_IMAGE_VERSION=8.2.2-r1 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/drush:/opt/bitnami/mysql/bin/:$PATH

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.23-9 --checksum 25bf5b82662874c21b0c0614c057d06b4a8ec14d8a76181053b691a9dfbf7f94
RUN bitnami-pkg install php-5.6.27-1 --checksum 1ce0f814b261be11b85e5a3c878698b558e98252f2e80fdb3e9c2e23c935b573
RUN bitnami-pkg install libphp-5.6.27-0 --checksum f9039cc69834334187c9b55fc20bf3be818cd87a2088ced2732fead1d1bfb2d6
RUN bitnami-pkg install mysql-client-10.1.18-0 --checksum f2f20e0512e7463996a6ad173156d249aa5ca746a1edb6c46449bd4d2736f725
RUN bitnami-pkg install drush-8.0.5-0 --checksum 51ec7d920b7931b8a65e26a7a45fe1b56ca482b566e45799a921587e59596b4b

# Install drupal

RUN bitnami-pkg unpack drupal-8.2.2-1 --checksum c0f544049f23244c37fa8f6f15ff5c0d3faac3fc658a6ad4f9a8d4692af6cfb6

COPY rootfs /

VOLUME ["/bitnami/drupal", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "apache"]
