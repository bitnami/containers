FROM gcr.io/stacksmith-images/minideb:jessie-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=dokuwiki \
    BITNAMI_IMAGE_VERSION=20160626a-r4 \
    PATH=/opt/bitnami/php/bin:$PATH

# System packages required
RUN install_packages libssl1.0.0 libaprutil1 libapr1 libc6 libuuid1 libexpat1 libpcre3 libldap-2.4-2 libsasl2-2 libgnutls-deb0-28 zlib1g libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libgmp10 libffi6 libxslt1.1 libtidy-0.99-0 libreadline6 libncurses5 libtinfo5 libsybdb5 libmcrypt4 libstdc++6 libpng12-0 libjpeg62-turbo libbz2-1.0 libxml2 libcurl3 libfreetype6 libicu52 libgcc1 libgcrypt20 libgssapi-krb5-2 liblzma5 libidn11 librtmp1 libssh2-1 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libkrb5support0 libkeyutils1

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.23-11 --checksum e4876fc1514082af221105319ddc8f069e7e2305dded70633bbf9a5973f2d9be
RUN bitnami-pkg install php-5.6.28-1 --checksum e6a6a80ccd36d3e6c4edd4c6dd97d6247534584f023bf89dda6d13728138ca37
RUN bitnami-pkg install libphp-5.6.28-1 --checksum c7a1df270fad99fbcff23506574ec1467bac4e0f0f6d0bd34bf310446ec5d7f5

# Install dokuwiki
RUN bitnami-pkg unpack dokuwiki-20160626a-0 --checksum dc458acf5ca9c4ab188938fcb7598547ad8ce9fef54e0d7515e6690e355f3d11

COPY rootfs /

VOLUME ["/bitnami/dokuwiki", "/bitnami/apache"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami","start","--foreground","apache"]
