## BUILDING
##   (from project root directory)
##   $ docker build -t bitnami/bitnami-docker-codeigniter .
##
## RUNNING
##   $ docker run -p 8000:8000 bitnami/bitnami-docker-codeigniter

FROM gcr.io/stacksmith-images/minideb:jessie-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=codeigniter \
    BITNAMI_IMAGE_VERSION=3.1.3-r0 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# System packages required
RUN install_packages libc6 zlib1g libxslt1.1 libtidy-0.99-0 libreadline6 libncurses5 libtinfo5 libsybdb5 libmcrypt4 libldap-2.4-2 libstdc++6 libgmp10 libpng12-0 libjpeg62-turbo libbz2-1.0 libxml2 libssl1.0.0 libcurl3 libfreetype6 libicu52 libgcc1 libgcrypt20 libgssapi-krb5-2 libgnutls-deb0-28 libsasl2-2 liblzma5 libidn11 librtmp1 libssh2-1 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libkrb5support0 libkeyutils1 libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libffi6 libaio1 libjemalloc1

# Additional modules required
RUN bitnami-pkg install php-7.0.14-0 --checksum 9144f590d0cbbf751288c27467128b5f95507729c22144008c453c94cd8ef8b9
RUN bitnami-pkg install mysql-client-10.1.20-0 --checksum 14d20929072b157b5e819deb440504ad0f33f583493b5adeb283c329ea58d513
RUN bitnami-pkg install mariadb-10.1.20-0 --checksum 7409ba139885bc4f463233a250806f557ee41472e2c88213e82c21f4d97a77d7

# Install codeigniter
RUN bitnami-pkg install codeigniter-3.1.3-0 --checksum 5d653ed41a2bf4f78818f5cb2c249fba83b9f041ca72a8d7a5f7c9c6d9d51131

COPY rootfs /

WORKDIR /app

EXPOSE 8000

ENV TERM=xterm

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["php", "-S", "0.0.0.0:8000"]
