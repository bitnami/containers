FROM gcr.io/stacksmith-images/ubuntu:14.04-r9

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=opencart \
    BITNAMI_APP_VERSION=2.3.0.2 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.23-1 --checksum c8d14a79313c5e47dbf617e9a55e88ff91d8361357386bab520aabccd35c59d8
RUN bitnami-pkg install php-5.6.25-0 --checksum f0e8d07d155abdb5d6843931d3ffbf9b4208fff248c409444fdd5a8e3a3da01d
RUN bitnami-pkg install libphp-5.6.21-2 --checksum 83d19b750b627fa70ed9613504089732897a48e1a7d304d8d73dec61a727b222
RUN bitnami-pkg install mysql-client-10.1.13-4 --checksum 14b45c91dd78b37f0f2366712cbe9bfdf2cb674769435611955191a65dbf4976

# Install opencart
RUN bitnami-pkg unpack opencart-2.3.0.2-0 --checksum 4afd97311b22d22e3919f365fdb67a1c8f4268f105277e51389debd42ccb83c3

COPY rootfs /

VOLUME ["/bitnami/opencart", "/bitnami/apache"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["harpoon", "start", "--foreground", "apache"]
