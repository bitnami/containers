FROM gcr.io/stacksmith-images/ubuntu:14.04-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=moodle \
    BITNAMI_IMAGE_VERSION=3.1.0-r1 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.20-0 --checksum ec415b0938e6df70327055c5be50f80b1307b785fa5bbd04c94a4077519e5dba
RUN bitnami-pkg install mysql-client-10.1.13-2 --checksum d82ac222dfc58f460aaba05a70260940e8c55ff0b24e4e3ed72dec5f2bfb37fd
RUN bitnami-pkg install php-5.6.23-0 --checksum 21f1d65e6f0721cbbad452ace681c5b1a41dec8aabe568140313dce045a0d537
RUN bitnami-pkg install libphp-5.6.21-0 --checksum 8c1f994108eb17c69b00ac38617997b8ffad7a145a83848f38361b9571aeb73e

# Install moodle
RUN bitnami-pkg unpack moodle-3.1.0-1 --checksum b397661d41a2970ef4f8e520486b8351beef6c1dc0e4493760a44f5f930ba99d

COPY rootfs /

VOLUME ["/bitnami/moodle", "/bitnami/apache"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["harpoon", "start", "--foreground", "apache"]
