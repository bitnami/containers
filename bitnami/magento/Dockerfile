FROM gcr.io/stacksmith-images/ubuntu:14.04-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=magento \
    BITNAMI_IMAGE_VERSION=2.1.1-r1 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/apache/bin:/opt/bitnami/magento/bin/:$PATH

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.23-5 --checksum ce7996de3c2173a72ad742e7ad0b4d48a1947454d4e0001497be74f19f9aa74c
RUN bitnami-pkg unpack php-7.0.11-1 --checksum cc9129523269e86728eb81ac489c65996214f22c6447bbff4c2306ec4be3c871
RUN bitnami-pkg install libphp-7.0.11-2 --checksum e91e9763027b68d9adc69dc30cef791bd826ce492a22ad0c66914a03f3e1bf57
RUN bitnami-pkg install mysql-client-10.1.13-4 --checksum 14b45c91dd78b37f0f2366712cbe9bfdf2cb674769435611955191a65dbf4976

# Install magento
RUN bitnami-pkg unpack magento-2.1.1-1 --checksum 744c18a9c3074211f170db6741bcd96e5c66aa3e31ca7445d6f845bdd83a6110

COPY rootfs /

VOLUME ["/bitnami/magento", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["/init.sh"]
