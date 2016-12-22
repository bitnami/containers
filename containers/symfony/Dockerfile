## BUILDING
##   (from project root directory)
##   $ docker build -t bitnami/bitnami-docker-symfony .
##
## RUNNING
##   $ docker run -p 8000:8000 bitnami/bitnami-docker-symfony

FROM gcr.io/stacksmith-images/minideb:jessie-r7

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=symfony \
    BITNAMI_IMAGE_VERSION=3.1.3-r5 \
    PATH=/opt/bitnami/symfony:/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# Additional modules required
RUN bitnami-pkg install php-7.0.11-1 --checksum cc9129523269e86728eb81ac489c65996214f22c6447bbff4c2306ec4be3c871
RUN bitnami-pkg install mysql-client-10.1.19-0 --checksum fdbc292bedabeaf0148d66770b8aa0ab88012ce67b459d6ba2b46446c91bb79c
RUN bitnami-pkg install mariadb-10.1.19-0 --checksum c54e3fdc689cdd2f2119914e4f255722f96f1d7fef37a064fd46fb84b013da7b

# Install symfony
RUN bitnami-pkg install symfony-3.1.3-1 --checksum 35c1c89157ff9d527a9644a4bd1d07ab00f2c3c12dad41cc45f9913a1d3ddbfa

COPY rootfs /

EXPOSE 8000

WORKDIR /app

ENV TERM=xterm

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["php", "-S", "0.0.0.0:8000"]
