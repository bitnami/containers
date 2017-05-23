FROM bitnami/minideb-extras:jessie-r15
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libcomerr2 libcurl3 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libicu52 libidn11 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libncurses5 libnettle4 libp11-kit0 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libstdc++6 libsybdb5 libtasn1-6 libtidy-0.99-0 libtinfo5 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg install php-7.0.19-0 --checksum dcd5e4a19792dbfde5157d33f09e3c030ac11da92606ade08576bea795d6ac53
RUN bitnami-pkg install mysql-client-10.1.23-1 --checksum 0be92fcc4f7fec93edfa7f788e2bbb87b5b3aac92dfdec159a10590345362512
RUN bitnami-pkg install symfony-3.3.0-0 --checksum 1aa1354bca64c782eac398c249d532baee7ea4b866dedc429f2260c47501d097

COPY rootfs /

ENV BITNAMI_APP_NAME="symfony" \
    BITNAMI_IMAGE_VERSION="3.3.0-r0" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT="3306" \
    MARIADB_USER="root" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/mysql/bin:/opt/bitnami/symfony/bin:$PATH" \
    SYMFONY_PROJECT_NAME="myapp"


EXPOSE 8000

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
