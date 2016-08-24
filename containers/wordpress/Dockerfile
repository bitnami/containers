FROM gcr.io/stacksmith-images/ubuntu:14.04-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=wordpress \
    BITNAMI_IMAGE_VERSION=4.6-r0 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# Additional modules required
RUN bitnami-pkg install php-5.6.25-0 --checksum f0e8d07d155abdb5d6843931d3ffbf9b4208fff248c409444fdd5a8e3a3da01d
RUN bitnami-pkg unpack apache-2.4.23-1 --checksum c8d14a79313c5e47dbf617e9a55e88ff91d8361357386bab520aabccd35c59d8
RUN bitnami-pkg install libphp-5.6.21-2 --checksum 83d19b750b627fa70ed9613504089732897a48e1a7d304d8d73dec61a727b222
RUN bitnami-pkg install mysql-client-10.1.13-4 --checksum 14b45c91dd78b37f0f2366712cbe9bfdf2cb674769435611955191a65dbf4976

# Install wordpress
RUN bitnami-pkg unpack wordpress-4.6-0 --checksum a2c4039e0dd22b1bed6947c2e651f11b472c9852de70db38cf66d5cea71da6bf

COPY rootfs /

VOLUME ["/bitnami/wordpress", "/bitnami/apache"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["harpoon", "start", "--foreground", "apache"]
