FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl dirmngr gnupg libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmemcached11 libmemcachedutil2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5 libtinfo5 libunistring0 libxml2 libxslt1.1 libzip4 procps sudo unzip zlib1g
RUN /build/bitnami-user.sh && \
    /build/install-nami.sh
RUN bitnami-pkg unpack apache-2.4.41-4 --checksum 496e9cc3e12fd38832aae5dc1873cb4593666e6146379f55b2312908917eb666
RUN bitnami-pkg unpack php-7.3.13-3 --checksum 88b3115407575a8906043ce9a54968104634b96473bb7493b9a3461b28683a6f
RUN bitnami-pkg install libphp-7.3.13-2 --checksum cdad3af7b23f54dbcf13818651979d7f23324c6092e5bde760eee1be1a740346
RUN bitnami-pkg unpack dokuwiki-0.20180422.201901061035-2 --checksum 745b45641bb08ed01d2139a7f4d0a111fbe139040aa601518b9a177cb69f8e0a
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/install-gosu.sh
RUN /build/install-tini.sh

COPY rootfs /
ENV BITNAMI_APP_NAME="dokuwiki" \
    BITNAMI_IMAGE_VERSION="0.20180422.201901061035-debian-9-r307" \
    DOKUWIKI_EMAIL="user@example.com" \
    DOKUWIKI_FULL_NAME="Full Name" \
    DOKUWIKI_PASSWORD="bitnami1" \
    DOKUWIKI_USERNAME="superuser" \
    DOKUWIKI_WIKI_NAME="Bitnami DokuWiki"

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "apache" ]
