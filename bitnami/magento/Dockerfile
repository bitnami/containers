FROM gcr.io/stacksmith-images/ubuntu:14.04-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=magento \
    BITNAMI_IMAGE_VERSION=2.1.2-r0 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/apache/bin:/opt/bitnami/magento/bin/:$PATH

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.23-7 --checksum bcbe93875f4017ed762caf73774a35b449e22c441e6b3f619f386294ba0a5958
RUN bitnami-pkg unpack php-7.0.12-0 --checksum 72ad07dae640cd2a34bccf7c81bbe4a1ec7cd55eec40fc4dc8eef7a450be493a
RUN bitnami-pkg install libphp-7.0.12-0 --checksum cf1a090ef79c2d1a7c9598a91e8dc7a485a5c3967aaee55cb08b23496fdbf1ee
RUN bitnami-pkg install mysql-client-10.1.13-4 --checksum 14b45c91dd78b37f0f2366712cbe9bfdf2cb674769435611955191a65dbf4976

# Install magento
RUN bitnami-pkg unpack magento-2.1.2-0 --checksum a1872b804e6d40e31b48a6d4d5a5758a1a6daad33a43c371a3163e5399157042

COPY rootfs /

VOLUME ["/bitnami/magento", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["/init.sh"]
