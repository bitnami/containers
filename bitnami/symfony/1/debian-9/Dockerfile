FROM bitnami/minideb-extras:stretch-r285
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libcomerr2 libcurl3 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libmemcached11 libmemcachedutil2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5 libtinfo5 libunistring0 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg install php-7.1.26-4 --checksum f754253881b698526840265dcbed1e77ef170fd74aa89c4bf2c5b1c8477061c9
RUN bitnami-pkg install mysql-client-10.1.38-0 --checksum 7202055a6688186df2570efea631940d25f5bb6ecd06f4e036c852d13ffded0c
RUN bitnami-pkg install symfony-1.5.11-20 --checksum e512f0bbcf6c8a6c01f87adcb8f193699a88db2f811986a65de2a0468c736fc8

COPY rootfs /
ENV BITNAMI_APP_NAME="symfony" \
    BITNAMI_IMAGE_VERSION="1.5.11-debian-9-r202" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_USER="root" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:/opt/bitnami/symfony/bin:$PATH" \
    SYMFONY_PROJECT_NAME="myapp"

EXPOSE 8000

WORKDIR /app
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
