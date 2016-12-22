FROM gcr.io/stacksmith-images/minideb:jessie-r7

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=suitecrm \
    BITNAMI_IMAGE_VERSION=7.7.8-r0 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/apache/bin:/opt/bitnami/mariadb/bin/:$PATH

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.23-9 --checksum 25bf5b82662874c21b0c0614c057d06b4a8ec14d8a76181053b691a9dfbf7f94
RUN bitnami-pkg install php-7.0.13-0 --checksum 9067aa50cb5d6870a5c59bfc66eb026dd45fb2ce76ebd206beef145c0f5dd2b1
RUN bitnami-pkg install libphp-7.0.13-0 --checksum 94a75d97f344d0afcfc16d15defa9388b7709a0324a8592ea82451cfd2134931
RUN bitnami-pkg install mysql-client-10.1.19-0 --checksum fdbc292bedabeaf0148d66770b8aa0ab88012ce67b459d6ba2b46446c91bb79c

# Install suitecrm
RUN bitnami-pkg unpack suitecrm-7.7.8-0 --checksum 62772fc6a991e9e65583574294410512b0741b04596375753f2040196e76c2d1

COPY rootfs /

VOLUME ["/bitnami/suitecrm", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["/init.sh"]
