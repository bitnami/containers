FROM gcr.io/stacksmith-images/minideb:jessie-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=suitecrm \
    BITNAMI_IMAGE_VERSION=7.7.9-r1 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/apache/bin:/opt/bitnami/mariadb/bin/:$PATH

# System packages required
RUN install_packages --no-install-recommends libssl1.0.0 libaprutil1 libapr1 libc6 libuuid1 libexpat1 libpcre3 libldap-2.4-2 libsasl2-2 libgnutls-deb0-28 zlib1g libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libgmp10 libffi6 libxslt1.1 libtidy-0.99-0 libreadline6 libncurses5 libtinfo5 libsybdb5 libmcrypt4 libstdc++6 libpng12-0 libjpeg62-turbo libbz2-1.0 libxml2 libcurl3 libfreetype6 libicu52 libgcc1 libgcrypt20 libgssapi-krb5-2 liblzma5 libidn11 librtmp1 libssh2-1 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libkrb5support0 libkeyutils1

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.25-0 --checksum 8b46af7d737772d7d301da8b30a2770b7e549674e33b8a5b07480f53c39f5c3f
RUN bitnami-pkg unpack php-7.0.14-0 --checksum 9144f590d0cbbf751288c27467128b5f95507729c22144008c453c94cd8ef8b9
RUN bitnami-pkg install libphp-7.0.14-0 --checksum 014983c16346dbdc5e25a73432d1b11bc027c8dd905af40863d80e426061ff88
RUN bitnami-pkg install mysql-client-10.1.20-0 --checksum 14d20929072b157b5e819deb440504ad0f33f583493b5adeb283c329ea58d513

# Install suitecrm
RUN bitnami-pkg unpack suitecrm-7.7.9-0 --checksum 57f24755287f99c829e616cd7fbf8e7e7dd9fcc583e4fd013ec1853cde8fe833

COPY rootfs /

VOLUME ["/bitnami/suitecrm", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["/init.sh"]
