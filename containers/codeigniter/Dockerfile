## BUILDING
##   (from project root directory)
##   $ docker build -t bitnami/bitnami-docker-codeigniter .
##
## RUNNING
##   $ docker run -p 8000:8000 bitnami/bitnami-docker-codeigniter

FROM gcr.io/stacksmith-images/minideb:jessie-r2

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=codeigniter \
    BITNAMI_IMAGE_VERSION=3.1.0-r4 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# Install Codeigniter dependencies
RUN bitnami-pkg install php-7.0.11-1 --checksum cc9129523269e86728eb81ac489c65996214f22c6447bbff4c2306ec4be3c871
RUN bitnami-pkg install mysql-client-10.1.19-0 --checksum fdbc292bedabeaf0148d66770b8aa0ab88012ce67b459d6ba2b46446c91bb79c
RUN bitnami-pkg install mariadb-10.1.19-0 --checksum c54e3fdc689cdd2f2119914e4f255722f96f1d7fef37a064fd46fb84b013da7b

# Install Codeigniter module
RUN bitnami-pkg install codeigniter-3.1.0-3 --checksum e3567135aa3c3356811bddb1545663258236f3e7eee20e28c5bd2ff58b2ed52d

COPY rootfs /

WORKDIR /app

EXPOSE 8000

ENV TERM=xterm

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["php", "-S", "0.0.0.0:8000"]
