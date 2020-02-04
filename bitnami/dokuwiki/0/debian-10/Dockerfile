FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl dirmngr gnupg libbz2-1.0 libc6 libcom-err2 libcurl4 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmemcached11 libmemcachedutil2 libncurses6 libnettle6 libnghttp2-14 libp11-kit0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libunistring2 libxml2 libxslt1.1 libzip4 procps sudo unzip zlib1g
RUN /build/bitnami-user.sh && \
    /build/install-nami.sh
RUN bitnami-pkg unpack apache-2.4.41-0 --checksum 0364e80e08a89fda2d2d302609f813d5d497b6cb6bcf6643d2770b825abbc0fb
RUN bitnami-pkg unpack php-7.3.14-0 --checksum 58ea3eac602c9e840afb1cde192bda1018c62e3485c41962bc0266b079dd731f
RUN bitnami-pkg install libphp-7.3.14-0 --checksum b9d1872eeaf47fe678aaefd4d5925be1bbab64d67f808c14d849039a204faad8
RUN bitnami-pkg unpack dokuwiki-0.20180422.201901061035-0 --checksum 35c3cbc0c72c53f853624e309a5af3d313b1f8757c34241caac611b24f2746f9
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/install-gosu.sh
RUN /build/install-tini.sh

COPY rootfs /
ENV BITNAMI_APP_NAME="dokuwiki" \
    BITNAMI_IMAGE_VERSION="0.20180422.201901061035-debian-10-r11" \
    DOKUWIKI_EMAIL="user@example.com" \
    DOKUWIKI_FULL_NAME="Full Name" \
    DOKUWIKI_PASSWORD="bitnami1" \
    DOKUWIKI_USERNAME="superuser" \
    DOKUWIKI_WIKI_NAME="Bitnami DokuWiki"

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "apache" ]
