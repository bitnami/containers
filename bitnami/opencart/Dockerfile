FROM gcr.io/stacksmith-images/minideb:jessie-r2

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=opencart \
    BITNAMI_IMAGE_VERSION=2.3.0.2-r6 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.23-10 --checksum 29195ce6cd437c2880fb7c627880932c7c13df6032fc7b25c1ae3bccd27b20e2
RUN bitnami-pkg install php-5.6.27-2 --checksum 84d7fe4036a4218afd79b006c9fad55eab3cfec7a47d3a86183805f863813001
RUN bitnami-pkg install libphp-5.6.27-0 --checksum f9039cc69834334187c9b55fc20bf3be818cd87a2088ced2732fead1d1bfb2d6
RUN bitnami-pkg install mysql-client-10.1.19-0 --checksum fdbc292bedabeaf0148d66770b8aa0ab88012ce67b459d6ba2b46446c91bb79c

# Install opencart
RUN bitnami-pkg unpack opencart-2.3.0.2-2 --checksum 00c350c4ca1ef2132d6abfd3fa483b8d2754e0fc04fbe26317741c28b42a1452

COPY rootfs /

VOLUME ["/bitnami/opencart", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "apache"]
