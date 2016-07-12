FROM gcr.io/stacksmith-images/ubuntu:14.04-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=prestashop \
    BITNAMI_IMAGE_VERSION=1.6.1.6-r1 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.20-0 --checksum ec415b0938e6df70327055c5be50f80b1307b785fa5bbd04c94a4077519e5dba
RUN bitnami-pkg install php-5.6.23-0 --checksum 21f1d65e6f0721cbbad452ace681c5b1a41dec8aabe568140313dce045a0d537
RUN bitnami-pkg install libphp-5.6.21-0 --checksum 8c1f994108eb17c69b00ac38617997b8ffad7a145a83848f38361b9571aeb73e
RUN bitnami-pkg install mysql-client-10.1.13-1 --checksum e16c0ace5cb779b486e52af83a56367f26af16a25b4ab92d8f4293f1bf307107

# Install prestashop
RUN bitnami-pkg unpack prestashop-1.6.1.6-0 --checksum b15c600d32a9f2538450e081fbe95520ead31b9711097e7c193dd7357b915248

COPY rootfs /

VOLUME ["/bitnami/prestashop", "/bitnami/apache"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["harpoon", "start", "--foreground", "apache"]
