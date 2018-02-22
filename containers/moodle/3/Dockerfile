FROM bitnami/minideb-extras:jessie-r24
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages cron libapr1 libaprutil1 libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libicu52 libidn11 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libncurses5 libnettle4 libp11-kit0 libpcre3 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libstdc++6 libsybdb5 libtasn1-6 libtidy-0.99-0 libtinfo5 libuuid1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.29-1 --checksum 42114e87aafb1d519ab33451b6836873bca125d78ce7423c5f7f1de4a7198596
RUN bitnami-pkg unpack php-7.1.14-0 --checksum b6b036115be30b4bc5f20d97b2dd84e68a59a753ee2d91379c1a94d48a271b43
RUN bitnami-pkg install mysql-client-10.1.31-0 --checksum c5140f9fd386782201b78559972045018928a405df324564deb392c6c61073c1
RUN bitnami-pkg install libphp-7.1.14-0 --checksum 0ea87909fb189aa0a34dbc54f9fbbdb4fc3cea3a986a1ca6e23842776b8f72e8
RUN bitnami-pkg unpack moodle-3.4.1-0 --checksum 9032a097a0c3e62a0eefe31b58202bc8607a69398c37fd44413f0825cca8890d
RUN sed -i -e '/pam_loginuid.so/ s/^#*/#/' /etc/pam.d/cron

COPY rootfs /

ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="moodle" \
    BITNAMI_IMAGE_VERSION="3.4.1-r1" \
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
