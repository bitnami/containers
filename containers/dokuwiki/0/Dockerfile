FROM bitnami/minideb-extras:jessie-r44
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libapr1 libaprutil1 libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libicu52 libidn11 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libncurses5 libnettle4 libp11-kit0 libpcre3 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libstdc++6 libsybdb5 libtasn1-6 libtidy-0.99-0 libtinfo5 libuuid1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.33-0 --checksum 8b7e149b571298efb73d476ba0a87df0d0f8aa17fa3adf0590ffc0d37bf5d6cf
RUN bitnami-pkg unpack php-7.0.30-2 --checksum 2ef097768570b3eee1730781bc2d73b44964b8399376da48096ff31392fc5091
RUN bitnami-pkg install libphp-7.0.30-1 --checksum e418d963a22c437510aa99d8154c758a68311013d1918d46e4f4a382855c0695
RUN bitnami-pkg unpack dokuwiki-0.20180422.201805030840-1 --checksum 423f749987b9fdf3eaf71f0b95258e4ed8c61e8153a0bcb9a27b0ab31d545f5e

COPY rootfs /
ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="dokuwiki" \
    BITNAMI_IMAGE_VERSION="0.20180422.201805030840-r9" \
    DOKUWIKI_EMAIL="user@example.com" \
    DOKUWIKI_FULL_NAME="Full Name" \
    DOKUWIKI_PASSWORD="bitnami1" \
    DOKUWIKI_USERNAME="superuser" \
    DOKUWIKI_WIKI_NAME="Bitnami DokuWiki" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:$PATH"

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","apache"]
