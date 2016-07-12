FROM gcr.io/stacksmith-images/ubuntu:14.04-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=magento \
    BITNAMI_IMAGE_VERSION=2.0.5-r0 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/apache/bin:/opt/bitnami/magento/bin/:$PATH

# Additional modules required
RUN bitnami-pkg install php-7.0.8-0 --checksum afc462c63a44a1abe5c130d1fdfad3ef88989b8b75d782c90538a0d1acaff4ee
RUN bitnami-pkg unpack apache-2.4.20-0 --checksum ec415b0938e6df70327055c5be50f80b1307b785fa5bbd04c94a4077519e5dba
RUN bitnami-pkg install libphp-7.0.6-0 --checksum ab1ae095760d5a5d45a232a6b22cca40d3a5fc9116ddc73cc535f740dbf99e46
RUN bitnami-pkg install mysql-client-10.1.13-2 --checksum d82ac222dfc58f460aaba05a70260940e8c55ff0b24e4e3ed72dec5f2bfb37fd

# Install magento
RUN bitnami-pkg unpack magento-2.0.5-1 --checksum 7c9aaf1f5f1dcd1f23d6b96b61edace39b72217f0ad98eb9b4bb001476efa36d

COPY rootfs /

VOLUME ["/bitnami/magento", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["/init.sh"]
