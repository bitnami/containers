FROM bitnami/minideb-extras:jessie-r23
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libapr1 libaprutil1 libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libicu52 libidn11 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libncurses5 libnettle4 libp11-kit0 libpcap0.8 libpcre3 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libstdc++6 libsybdb5 libtasn1-6 libtidy-0.99-0 libtinfo5 libuuid1 libuv0.10 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.29-0 --checksum 38af9f5ee6088655536238d9f70f4ce7fd6047e1c84fd5b02fa351efbc4f60c6
RUN bitnami-pkg install redis-client-4.0.6-0 --checksum 095c8bfdf611c3662bef93a850a59efe121c761aeba238f0e6e5d1881b3b3d54
RUN bitnami-pkg unpack php-7.0.27-0 --checksum 9e5a1ce65fce97b1c785cf8699c91de4a11c8d0bd8959e4b14a319fa0180b46f
RUN bitnami-pkg install mysql-client-10.1.30-0 --checksum 2f7bfecc0e405c53c0dc0508670af2b87124fbf3475f597fe8359e85d14e2a0c
RUN bitnami-pkg install mongodb-client-3.6.2-0 --checksum 2e7359b400a81e8f61e85676ae186b714e232b0b8b329f82c9cf46861b33f514
RUN bitnami-pkg install libphp-7.0.27-0 --checksum b4936b7e66fca5a2bfb5c2a3ded1683d8c743894cdf8e15f7d5bde0413abd35d
RUN bitnami-pkg unpack dreamfactory-2.11.0-0 --checksum 579b10c4ea4e8a6f28c2329733bc5e35e54e8ad50a9c064ae7a34a1d477500f2

COPY rootfs /

ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="dreamfactory" \
    BITNAMI_IMAGE_VERSION="2.11.0-r0" \
    MARIADB_HOST="mariadb" \
    MARIADB_PASSWORD="" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_USER="root" \
    MONGODB_HOST="mongodb" \
    MONGODB_PASSWORD="" \
    MONGODB_PORT_NUMBER="27017" \
    MONGODB_USER="" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/redis-client/bin:/opt/bitnami/php/bin:/opt/bitnami/mysql/bin:/opt/bitnami/mongodb/bin:$PATH" \
    REDIS_HOST="redis" \
    REDIS_PASSWORD="" \
    REDIS_PORT_NUMBER="6379" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER=""

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","apache"]
