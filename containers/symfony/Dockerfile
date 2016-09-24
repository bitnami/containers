## BUILDING
##   (from project root directory)
##   $ docker build -t bitnami/bitnami-docker-symfony .
##
## RUNNING
##   $ docker run -p 8000:8000 bitnami/bitnami-docker-symfony

FROM gcr.io/stacksmith-images/ubuntu:14.04-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=symfony \
    BITNAMI_APP_VERSION=3.1.3-r1 \
    PATH=/opt/bitnami/symfony:/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# Additional modules required
RUN bitnami-pkg install php-7.0.11-1 --checksum cc9129523269e86728eb81ac489c65996214f22c6447bbff4c2306ec4be3c871
RUN bitnami-pkg install mysql-client-10.1.13-4 --checksum 14b45c91dd78b37f0f2366712cbe9bfdf2cb674769435611955191a65dbf4976
RUN bitnami-pkg install mariadb-10.1.17-1 --checksum 003be4c827669dae149d4a4639dfc7dcb5766b76aeccf477b4912ae000290768

# Install symfony
RUN bitnami-pkg install symfony-3.1.3-0 --checksum 93cdf97999dc72fcfac444e8ab12797452cc5b02c16d05e092e5a537af41e70c


COPY rootfs /

EXPOSE 8000

WORKDIR /app

ENV TERM=xterm

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["php", "-S", "0.0.0.0:8000"]
