FROM bitnami/minideb-extras:jessie-r20

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=codeigniter \
    BITNAMI_IMAGE_VERSION=3.1.3-r7 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# System packages required
RUN install_packages libc6 zlib1g libxslt1.1 libtidy-0.99-0 libreadline6 libncurses5 libtinfo5 libsybdb5 libmcrypt4 libldap-2.4-2 libstdc++6 libgmp10 libpng12-0 libjpeg62-turbo libbz2-1.0 libxml2 libssl1.0.0 libcurl3 libfreetype6 libicu52 libgcc1 libgcrypt20 libgssapi-krb5-2 libgnutls-deb0-28 libsasl2-2 liblzma5 libidn11 librtmp1 libssh2-1 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libkrb5support0 libkeyutils1 libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libffi6 libaio1 libjemalloc1

# Additional modules required
RUN bitnami-pkg install php-7.1.7-0 --checksum e89b2b7a83ba84fb66f2bbe13c82a68b5625bed10fa3150f561eec95157d0680
RUN bitnami-pkg install mysql-client-10.1.24-0 --checksum 3ac33998eefe09a8013036d555f2a8265fc446a707e8d61c63f8621f4a3e5dae

# Install codeigniter
RUN bitnami-pkg install codeigniter-3.1.3-2 --checksum 223632dc30c8176e7a81f38ab23f06e69efa8ed7cb91b50a47723f494062bc9c

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
