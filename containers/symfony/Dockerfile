## BUILDING
##   (from project root directory)
##   $ docker build -t bitnami/bitnami-docker-symfony .
##
## RUNNING
##   $ docker run -p 8000:8000 bitnami/bitnami-docker-symfony

FROM gcr.io/stacksmith-images/minideb:jessie-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=symfony \
    BITNAMI_IMAGE_VERSION=3.2.1-r3 \
    PATH=/opt/bitnami/symfony/bin:/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# System packages required
RUN install_packages libc6 zlib1g libxslt1.1 libtidy-0.99-0 libreadline6 libncurses5 libtinfo5 libmcrypt4 libldap-2.4-2 libstdc++6 libgmp10 libpng12-0 libjpeg62-turbo libbz2-1.0 libxml2 libssl1.0.0 libcurl3 libfreetype6 libicu52 libgcc1 libgcrypt20 libsasl2-2 libgnutls-deb0-28 liblzma5 libidn11 librtmp1 libssh2-1 libgssapi-krb5-2 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libkrb5support0 libkeyutils1 libffi6 libsybdb5 libpq5

# Additional modules required
RUN bitnami-pkg install php-7.0.15-3 --checksum 68961e83c3c66310d9a302818a3294c918f36a4c54ad7c0f9a5576c4ce3f33ee
RUN bitnami-pkg install mysql-client-10.1.21-0 --checksum 8e868a3e46bfa59f3fb4e1aae22fd9a95fd656c020614a64706106ba2eba224e
RUN if [ "$BITNAMI_IMAGE_VERSION" = "3.2.1-r2" ] ; then bitnami-pkg install mariadb-10.1.20-0 --checksum 7409ba139885bc4f463233a250806f557ee41472e2c88213e82c21f4d97a77d7; fi

# Install symfony
RUN bitnami-pkg install symfony-3.2.1-1 --checksum 722420e64069685884ae05bbd025871794287295d2d80cc8417467c7c4095a2d

COPY rootfs /

EXPOSE 8000

WORKDIR /app

ENV TERM=xterm

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["php", "-S", "0.0.0.0:8000"]
