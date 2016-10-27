FROM gcr.io/stacksmith-images/ubuntu:14.04-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=suitecrm \
    BITNAMI_IMAGE_VERSION=7.7.4-r1 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/apache/bin:/opt/bitnami/mariadb/bin/:$PATH

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.23-5 --checksum ce7996de3c2173a72ad742e7ad0b4d48a1947454d4e0001497be74f19f9aa74c
RUN bitnami-pkg install php-7.0.12-0 --checksum 72ad07dae640cd2a34bccf7c81bbe4a1ec7cd55eec40fc4dc8eef7a450be493a
RUN bitnami-pkg install libphp-7.0.12-0 --checksum cf1a090ef79c2d1a7c9598a91e8dc7a485a5c3967aaee55cb08b23496fdbf1ee
RUN bitnami-pkg install mysql-client-10.1.18-0 --checksum f2f20e0512e7463996a6ad173156d249aa5ca746a1edb6c46449bd4d2736f725

# Install suitecrm
RUN bitnami-pkg unpack suitecrm-7.7.4-1 --checksum e0bd13dbd6f5bcbbc3f6d248178a25019e2c9c52d74e861b1b279514dd2b6a2b

COPY rootfs /

VOLUME ["/bitnami/suitecrm", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["/init.sh"]
