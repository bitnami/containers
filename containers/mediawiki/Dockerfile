FROM gcr.io/stacksmith-images/ubuntu:14.04-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=mediawiki \
    BITNAMI_IMAGE_VERSION=1.26.3-r1 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.20-0 --checksum ec415b0938e6df70327055c5be50f80b1307b785fa5bbd04c94a4077519e5dba
RUN bitnami-pkg install mysql-client-10.1.13-1 --checksum e16c0ace5cb779b486e52af83a56367f26af16a25b4ab92d8f4293f1bf307107
RUN bitnami-pkg install php-5.6.22-0 --checksum 2439cf0adfc7cc21f15a6136059883e749958af83a082108e63a80ff3c5290c0
RUN bitnami-pkg install libphp-5.6.21-0 --checksum 8c1f994108eb17c69b00ac38617997b8ffad7a145a83848f38361b9571aeb73e

# Install mediawiki
RUN bitnami-pkg unpack mediawiki-1.26.3-0 --checksum 2d26e8389aefa954f12d1699f79e3f03bd9108aa429cb9505646347b0b7d06ef

COPY rootfs /

VOLUME ["/bitnami/mediawiki", "/bitnami/apache"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["harpoon", "start", "--foreground", "apache"]
