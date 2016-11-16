FROM gcr.io/stacksmith-images/minideb:jessie-r2

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=magento \
    BITNAMI_IMAGE_VERSION=2.1.2-r4 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/apache/bin:/opt/bitnami/magento/bin/:$PATH

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.23-9 --checksum 25bf5b82662874c21b0c0614c057d06b4a8ec14d8a76181053b691a9dfbf7f94
RUN bitnami-pkg unpack php-7.0.13-0 --checksum 9067aa50cb5d6870a5c59bfc66eb026dd45fb2ce76ebd206beef145c0f5dd2b1
RUN bitnami-pkg install libphp-7.0.12-0 --checksum cf1a090ef79c2d1a7c9598a91e8dc7a485a5c3967aaee55cb08b23496fdbf1ee
RUN bitnami-pkg install mysql-client-10.1.19-0 --checksum fdbc292bedabeaf0148d66770b8aa0ab88012ce67b459d6ba2b46446c91bb79c

# Install magento
RUN bitnami-pkg unpack magento-2.1.2-3 --checksum 4822264544bb117db3ca8659b2e1b32806c63927b9c7ff5aa329f853df108fb7

COPY rootfs /

VOLUME ["/bitnami/magento", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["/init.sh"]
