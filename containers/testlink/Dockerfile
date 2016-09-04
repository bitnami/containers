FROM gcr.io/stacksmith-images/ubuntu:14.04-r9

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=testlink \
    BITNAMI_IMAGE_VERSION=1.9.14-r0 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# Additional modules required
RUN bitnami-pkg install php-5.6.23-0 --checksum 21f1d65e6f0721cbbad452ace681c5b1a41dec8aabe568140313dce045a0d537
RUN bitnami-pkg unpack apache-2.4.20-0 --checksum ec415b0938e6df70327055c5be50f80b1307b785fa5bbd04c94a4077519e5dba
RUN bitnami-pkg install libphp-5.6.21-0 --checksum 8c1f994108eb17c69b00ac38617997b8ffad7a145a83848f38361b9571aeb73e
RUN bitnami-pkg install mysql-client-10.1.13-1 --checksum e16c0ace5cb779b486e52af83a56367f26af16a25b4ab92d8f4293f1bf307107

# Install testlink
RUN bitnami-pkg unpack testlink-1.9.14-0 --checksum be3736e4ac44d3145fe13ad1225666a0f69d0babd88483d7db069220a00daab2

COPY rootfs /

VOLUME ["/bitnami/apache", "/bitnami/testlink"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "apache"]
