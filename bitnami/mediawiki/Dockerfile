FROM gcr.io/stacksmith-images/ubuntu:14.04-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=mediawiki \
    BITNAMI_IMAGE_VERSION=1.27.0-r0 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.23-0 --checksum 90b395bdb707cdbfc7786d79c4c064cade1135f94ff7f973d359c28c5ee8cebf
RUN bitnami-pkg install mysql-client-10.1.13-2 --checksum d82ac222dfc58f460aaba05a70260940e8c55ff0b24e4e3ed72dec5f2bfb37fd
RUN bitnami-pkg install php-5.6.24-0 --checksum bd4d033027f86efe21d743e66273dea113efb5d9d6eb778bf12a004719736928
RUN bitnami-pkg install libphp-5.6.21-0 --checksum 8c1f994108eb17c69b00ac38617997b8ffad7a145a83848f38361b9571aeb73e

# Install mediawiki
RUN bitnami-pkg unpack mediawiki-1.27.0-0 --checksum 7e427a565ef02271c0dd65b0c77b1bcb539a1f970e4ccdfcc4047b9c80960691

COPY rootfs /

VOLUME ["/bitnami/mediawiki", "/bitnami/apache"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["harpoon", "start", "--foreground", "apache"]
