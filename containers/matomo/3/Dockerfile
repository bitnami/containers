FROM bitnami/minideb-extras:jessie-r13

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=piwik \
    BITNAMI_IMAGE_VERSION=3.0.3-r0 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# System packages required
RUN install_packages libaprutil1 libapr1 libc6 libuuid1 libexpat1 libssl1.0.0 libpcre3 libldap-2.4-2 libsasl2-2 libgnutls-deb0-28 zlib1g libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libgmp10 libffi6 libxslt1.1 libtidy-0.99-0 libreadline6 libncurses5 libtinfo5 libmcrypt4 libstdc++6 libpng12-0 libjpeg62-turbo libbz2-1.0 libxml2 libcurl3 libfreetype6 libicu52 libgcc1 libgcrypt20 liblzma5 libidn11 librtmp1 libssh2-1 libgssapi-krb5-2 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libkrb5support0 libkeyutils1 libsybdb5 libpq5

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.25-0 --checksum 8b46af7d737772d7d301da8b30a2770b7e549674e33b8a5b07480f53c39f5c3f
RUN bitnami-pkg unpack php-7.0.17-0 --checksum 70fb42218e5b75b81683e6b13034211dfe31a6488d90aa5c79e5edb52ed08ddf
RUN bitnami-pkg install libphp-7.0.17-0 --checksum 9b0e8729e6f812e84e43e1aa07c01557690c8fef49ba84a6107c2e7d6636996a
RUN bitnami-pkg install mysql-client-10.1.22-3 --checksum 9e881a7c404f658c93abd665ecd1372f61a591d784e6456c64c0129358a7ff1a

# Install piwik
RUN bitnami-pkg unpack piwik-3.0.3-0 --checksum fcbbc3c1bfeeee310662da225e92085042585d7bdf2b17526595d78965810fbe

COPY rootfs /

ENV APACHE_HTTP_PORT="80" \
    APACHE_HTTPS_PORT="443" \
    PIWIK_USERNAME="User" \
    PIWIK_PASSWORD="bitnami" \
    PIWIK_EMAIL="user@example.com" \
    PIWIK_WEBSITE_NAME="example" \
    PIWIK_WEBSITE_HOST="https://example.org" \
    MARIADB_USER="root" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT="3306"

VOLUME ["/bitnami/piwik", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami","start","--foreground","apache"]
