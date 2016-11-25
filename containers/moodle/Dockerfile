FROM gcr.io/stacksmith-images/minideb:jessie-r2

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=moodle \
    BITNAMI_IMAGE_VERSION=3.1.3-r1 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.23-10 --checksum 29195ce6cd437c2880fb7c627880932c7c13df6032fc7b25c1ae3bccd27b20e2
RUN bitnami-pkg install php-5.6.28-0 --checksum 703ee1e4aa2fb1d3739633972aadae0e6620bd6c4d8520cea08f5ba9bfa589f2
RUN bitnami-pkg install libphp-5.6.27-0 --checksum f9039cc69834334187c9b55fc20bf3be818cd87a2088ced2732fead1d1bfb2d6
RUN bitnami-pkg install mysql-client-10.1.19-0 --checksum fdbc292bedabeaf0148d66770b8aa0ab88012ce67b459d6ba2b46446c91bb79c

# Install moodle
RUN bitnami-pkg unpack moodle-3.1.3-0 --checksum 7c0ee072294724804f460f8b1a7f268cae2653df3c8fb92670ec79b423eece93

COPY rootfs /

VOLUME ["/bitnami/moodle", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "apache"]
