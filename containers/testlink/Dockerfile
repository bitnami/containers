FROM gcr.io/stacksmith-images/minideb:jessie-r2

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=testlink \
    BITNAMI_IMAGE_VERSION=1.9.14-r5 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.23-10 --checksum 29195ce6cd437c2880fb7c627880932c7c13df6032fc7b25c1ae3bccd27b20e2
RUN bitnami-pkg unpack php-5.6.26-1 --checksum b7a72ae78f9b19352bd400dfe027465c88a8643c0e5d9753f8d12f4ebae542a2
RUN bitnami-pkg install libphp-5.6.26-1 --checksum 327d070f57727f2ed4f0246d0e3f61c5a94f6366d21a7e7e4572fe6c9c8e8c2d
RUN bitnami-pkg install mysql-client-10.1.13-4 --checksum 14b45c91dd78b37f0f2366712cbe9bfdf2cb674769435611955191a65dbf4976

# Install testlink
RUN bitnami-pkg unpack testlink-1.9.14-0 --checksum be3736e4ac44d3145fe13ad1225666a0f69d0babd88483d7db069220a00daab2

COPY rootfs /

VOLUME ["/bitnami/apache", "/bitnami/testlink", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "apache"]
