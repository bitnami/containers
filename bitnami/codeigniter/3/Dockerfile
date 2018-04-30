FROM bitnami/minideb-extras:jessie-r35

LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_APP_NAME=codeigniter \
    BITNAMI_IMAGE_VERSION=3.1.8-r0 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# System packages required
RUN install_packages libc6 zlib1g libxslt1.1 libtidy-0.99-0 libreadline6 libncurses5 libtinfo5 libsybdb5 libmcrypt4 libldap-2.4-2 libstdc++6 libgmp10 libpng12-0 libjpeg62-turbo libbz2-1.0 libxml2 libssl1.0.0 libcurl3 libfreetype6 libicu52 libgcc1 libgcrypt20 libgssapi-krb5-2 libgnutls-deb0-28 libsasl2-2 liblzma5 libidn11 librtmp1 libssh2-1 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libkrb5support0 libkeyutils1 libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libffi6 libaio1 libjemalloc1

# Additional modules required
RUN bitnami-pkg install php-7.1.17-0 --checksum f571a800da237fd50ea9d6a8d1f5b56a9ff73b2b9d40a6648a7556ac9a676829
RUN bitnami-pkg install mysql-client-10.1.32-0 --checksum e65dc7fa2dd7fa6cac74d62a2cff2e3d40f650e721ac955381dc7b6f83d4a141

# Install codeigniter
RUN bitnami-pkg install codeigniter-3.1.8-0 --checksum 636d2a11c21c8d7e92a53e45107ccff5fc66f20ce125252bc77257f2b12863f4

COPY rootfs /

ENV MARIADB_USER="root" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    CODEIGNITER_PROJECT_NAME="myapp" \
    TERM=xterm

WORKDIR /app

EXPOSE 8000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["php", "-S", "0.0.0.0:8000"]
