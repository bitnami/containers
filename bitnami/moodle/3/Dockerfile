FROM bitnami/minideb-extras:jessie-r23
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages cron libapr1 libaprutil1 libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libicu52 libidn11 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libncurses5 libnettle4 libp11-kit0 libpcre3 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libstdc++6 libsybdb5 libtasn1-6 libtidy-0.99-0 libtinfo5 libuuid1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.29-0 --checksum 38af9f5ee6088655536238d9f70f4ce7fd6047e1c84fd5b02fa351efbc4f60c6
RUN bitnami-pkg unpack php-7.1.13-0 --checksum e1ae013d572271de4097e6fc5aa4ed8364a492546dfcdddbcdd68c861a5af9cf
RUN bitnami-pkg install mysql-client-10.1.30-0 --checksum 2f7bfecc0e405c53c0dc0508670af2b87124fbf3475f597fe8359e85d14e2a0c
RUN bitnami-pkg install libphp-7.1.13-0 --checksum a15b96b7bab22313c47ecc3e7182d644baeb49467f1bdbc64792123c1a5ae5b5
RUN bitnami-pkg unpack moodle-3.4.0-1 --checksum 329dd287da8287a3a2a904cc6d52c55cac680fff05798ddac285719a72f8ef03
RUN sed -i -e '/pam_loginuid.so/ s/^#*/#/' /etc/pam.d/cron

COPY rootfs /

ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="moodle" \
    BITNAMI_IMAGE_VERSION="3.4.0-r1" \
    MARIADB_HOST="mariadb" \
    MARIADB_PASSWORD="" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_USER="root" \
    MOODLE_EMAIL="user@example.com" \
    MOODLE_LANGUAGE="en" \
    MOODLE_PASSWORD="bitnami" \
    MOODLE_SITENAME="New Site" \
    MOODLE_USERNAME="user" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/mysql/bin:$PATH" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER=""

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
