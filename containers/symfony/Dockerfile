## BUILDING
##   (from project root directory)
##   $ docker build -t bitnami/bitnami-docker-javaplay .
##
## RUNNING
##   $ docker run -p 9000:9000 bitnami/bitnaxmi-docker-javaplay

FROM gcr.io/stacksmith-images/ubuntu:14.04-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=symfony \
    BITNAMI_APP_VERSION=2.8.9 \
    PATH=/opt/bitnami/symfony/bin:/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# Additional modules required
RUN bitnami-pkg install php-7.0.10-0 --checksum 5f2ec47fcfb2fec5197af6760c5053dd5dee8084d70a488fd5ea77bd4245c6b9
ENV PATH=/opt/bitnami/php/bin:$PATH
RUN bitnami-pkg install mysql-client-10.1.13-4 --checksum 14b45c91dd78b37f0f2366712cbe9bfdf2cb674769435611955191a65dbf4976
ENV PATH=/opt/bitnami/mysql/bin:$PATH
RUN bitnami-pkg install mariadb-10.1.14-4 --checksum 4a75f4f52587853d69860662626c64a4540126962cd9ee9722af58a3e7cfa01b
RUN bitnami-pkg install symfony-2.8.9-0 --checksum e14979a9ed1a332bdd709ecc997ccc1ba7be0c680818e69ad5671ef0776df84e
ENV PATH=/opt/bitnami/symfony:$PATH

# Install symfony
ADD symfony-2.8.9-0-linux-x64.tar.gz /tmp 
RUN harpoon unpack /tmp/symfony-2.8.9-0-linux-x64

ENV PATH=/opt/bitnami/symfony:$PATH

COPY rootfs /

VOLUME ["/app"]

EXPOSE 9000

WORKDIR /app

USER bitnami

ENV TERM=xterm

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["php", "-S", "0.0.0.0:9000"]
