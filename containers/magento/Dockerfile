FROM gcr.io/stacksmith-images/ubuntu:14.04-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=magento \
    BITNAMI_IMAGE_VERSION=2.1.1-r0 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/apache/bin:/opt/bitnami/magento/bin/:$PATH

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.23-3 --checksum b75ced97d6b6f9dd8d0114ee0ca3943250af6edc91a20857f68165e4bf7d35fa
RUN bitnami-pkg unpack php-7.0.11-0 --checksum 7c8203e315d4adba00d7b80ec8b527e572a47e7739a1d0d23ca348eef3d4093a
RUN bitnami-pkg install libphp-7.0.11-0 --checksum 5607228fc09750339e75df85807592f5c24d1844d924d2a5acb2bc2b138e4984
RUN bitnami-pkg install mysql-client-10.1.13-4 --checksum 14b45c91dd78b37f0f2366712cbe9bfdf2cb674769435611955191a65dbf4976

# Install magento
RUN bitnami-pkg unpack magento-2.1.1-1 --checksum 744c18a9c3074211f170db6741bcd96e5c66aa3e31ca7445d6f845bdd83a6110

COPY rootfs /

VOLUME ["/bitnami/magento", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["/init.sh"]
