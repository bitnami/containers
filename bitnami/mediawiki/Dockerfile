FROM gcr.io/stacksmith-images/ubuntu:14.04-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=mediawiki \
    BITNAMI_IMAGE_VERSION=1.27.0-r2 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.23-5 --checksum ce7996de3c2173a72ad742e7ad0b4d48a1947454d4e0001497be74f19f9aa74c
RUN bitnami-pkg install mysql-client-10.1.13-4 --checksum 14b45c91dd78b37f0f2366712cbe9bfdf2cb674769435611955191a65dbf4976
RUN bitnami-pkg unpack php-5.6.26-1 --checksum b7a72ae78f9b19352bd400dfe027465c88a8643c0e5d9753f8d12f4ebae542a2
RUN bitnami-pkg install libphp-5.6.26-1 --checksum 327d070f57727f2ed4f0246d0e3f61c5a94f6366d21a7e7e4572fe6c9c8e8c2d

# Install mediawiki
RUN bitnami-pkg unpack mediawiki-1.27.0-0 --checksum 7e427a565ef02271c0dd65b0c77b1bcb539a1f970e4ccdfcc4047b9c80960691

COPY rootfs /

VOLUME ["/bitnami/mediawiki", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "apache"]
