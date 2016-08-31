## BUILDING
##   (from project root directory)
##   $ docker build -t bitnami/bitnami-docker-symfony .
##
## RUNNING
##   $ docker run -p 8000:8000 bitnami/bitnami-docker-symfony

FROM gcr.io/stacksmith-images/ubuntu:14.04-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=symfony \
    BITNAMI_APP_VERSION=2.8.9 \
    PATH=/opt/bitnami/symfony:/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# Additional modules required
RUN bitnami-pkg install php-7.0.10-0 --checksum 5f2ec47fcfb2fec5197af6760c5053dd5dee8084d70a488fd5ea77bd4245c6b9
RUN bitnami-pkg install mysql-client-10.1.13-4 --checksum 14b45c91dd78b37f0f2366712cbe9bfdf2cb674769435611955191a65dbf4976
RUN bitnami-pkg install mariadb-10.1.14-4 --checksum 4a75f4f52587853d69860662626c64a4540126962cd9ee9722af58a3e7cfa01b

# Install symfony
RUN bitnami-pkg unpack symfony-2.8.9-0 --checksum fb3b9e203f4abcd435bbbe79b41fe1f394b06f3036cde1315b61caed231bc9e0

COPY rootfs /

VOLUME ["/app"]

EXPOSE 8000

WORKDIR /app

USER bitnami

ENV TERM=xterm

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["php", "-S", "0.0.0.0:8000"]
