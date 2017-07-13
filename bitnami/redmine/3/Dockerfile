FROM bitnami/minideb-extras:jessie-r19
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbsd0 libbz2-1.0 libc6 libcomerr2 libcurl3 libedit2 libexpat1 libffi6 libfftw3-double3 libfontconfig1 libfreetype6 libgcc1 libgcrypt20 libglib2.0-0 libgmp-dev libgmp10 libgnutls-deb0-28 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed2 libidn11 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-2 libmysqlclient18 libncurses5 libnettle4 libp11-kit0 libpcre3 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libstdc++6 libtasn1-6 libtinfo5 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxml2-dev libxslt1-dev libxslt1.1 zlib1g zlib1g-dev
RUN bitnami-pkg install ruby-2.3.4-0 --checksum 92d6db7a6ba0893334e9d1d46a66a7459df08e151762f87942d6b0f29db0171a
RUN bitnami-pkg install postgresql-client-9.6.3-0 --checksum fec96be76c0ba5f66a56fbc002b45092abc0100a6d9409d26ddc7391610236de
RUN bitnami-pkg install mysql-client-10.1.25-0 --checksum 513ef36ab1efa5570332547c2027ae29886fe4bb56472de11ca083423a3fe366
RUN bitnami-pkg install git-2.13.3-0 --checksum 4368a02999de8ce0b3b8c897fbe2534d472ac9ccbffb8abcd08dd26fb0da9847
RUN bitnami-pkg unpack redmine-3.4.1-2 --checksum 4eb3a849153a18564590d7667fb8ad4aa5adb3376d007e2315efe10b052f66ef

COPY rootfs /

ENV BITNAMI_APP_NAME="redmine" \
    BITNAMI_IMAGE_VERSION="3.4.1-r2" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:$PATH" \
    REDMINE_DB_MYSQL="mariadb" \
    REDMINE_DB_PASSWORD="" \
    REDMINE_DB_PORT_NUMBER="" \
    REDMINE_DB_POSTGRES="" \
    REDMINE_DB_USERNAME="" \
    REDMINE_EMAIL="user@example.com" \
    REDMINE_LANGUAGE="en" \
    REDMINE_PASSWORD="bitnami1" \
    REDMINE_USERNAME="user" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_TLS="true" \
    SMTP_USER=""

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
