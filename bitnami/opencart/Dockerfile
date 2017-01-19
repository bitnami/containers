FROM gcr.io/stacksmith-images/minideb:jessie-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=opencart \
    BITNAMI_IMAGE_VERSION=2.3.0.2-r12 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# System packages required
RUN install_packages --no-install-recommends libssl1.0.0 libaprutil1 libapr1 libc6 libuuid1 libexpat1 libpcre3 libldap-2.4-2 libsasl2-2 libgnutls-deb0-28 zlib1g libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libgmp10 libffi6 libxslt1.1 libtidy-0.99-0 libreadline6 libncurses5 libtinfo5 libsybdb5 libmcrypt4 libstdc++6 libpng12-0 libjpeg62-turbo libbz2-1.0 libxml2 libcurl3 libfreetype6 libicu52 libgcc1 libgcrypt20 libgssapi-krb5-2 liblzma5 libidn11 librtmp1 libssh2-1 libkrb5-3 libk5crypto3 libcomerr2 libgpg-error0 libkrb5support0 libkeyutils1

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.23-11 --checksum e4876fc1514082af221105319ddc8f069e7e2305dded70633bbf9a5973f2d9be
RUN bitnami-pkg unpack php-5.6.28-1 --checksum e6a6a80ccd36d3e6c4edd4c6dd97d6247534584f023bf89dda6d13728138ca37
RUN bitnami-pkg install libphp-5.6.28-1 --checksum c7a1df270fad99fbcff23506574ec1467bac4e0f0f6d0bd34bf310446ec5d7f5
RUN bitnami-pkg install mysql-client-10.1.19-1 --checksum 2d946c8ee3e2e845f68a5cf3751d6477d88af194d263842797fe50a44414a173

# Install opencart
RUN bitnami-pkg unpack opencart-2.3.0.2-3 --checksum 92e9d059beff6cea9df091cc197bcd093642f2e630d331bd33a0fb141f7cf969

COPY rootfs /

VOLUME ["/bitnami/opencart", "/bitnami/apache", "/bitnami/php"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "apache"]
