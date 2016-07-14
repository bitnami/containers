FROM gcr.io/stacksmith-images/ubuntu:14.04-r07

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=wordpress \
    BITNAMI_IMAGE_VERSION=4.5.3-r0 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/drush:/opt/bitnami/mysql/bin/:$PATH

# Additional modules required
RUN bitnami-pkg install php-5.6.21-0 --checksum 1e0ebe2f26edea96b583d8b7ba2bf895b3c03ea40d67dfb1df3bf331c9caad6c
RUN bitnami-pkg unpack apache-2.4.18-2 --checksum 9722f4f470e036b4ed4f0fe98509e24f7182177b54a268a458af5eb8e7e6370a
RUN bitnami-pkg install libphp-5.6.21-0 --checksum 8c1f994108eb17c69b00ac38617997b8ffad7a145a83848f38361b9571aeb73e
RUN bitnami-pkg install mysql-client-10.1.13-1 --checksum e16c0ace5cb779b486e52af83a56367f26af16a25b4ab92d8f4293f1bf307107

# Install wordpress
RUN bitnami-pkg unpack wordpress-4.5.3-0 --checksum 32f11d14b6c1394ffebd9134519554b0dd7a8d973971ac8df2e823a7528cc88d

COPY rootfs /

VOLUME ["/bitnami/wordpress", "/bitnami/apache"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["harpoon", "start", "--foreground", "apache"]
