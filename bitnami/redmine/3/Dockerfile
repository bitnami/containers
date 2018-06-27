FROM bitnami/minideb-extras:jessie-r88
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbsd0 libbz2-1.0 libc6 libcomerr2 libcurl3 libedit2 libexpat1 libffi6 libfftw3-double3 libfontconfig1 libfreetype6 libgcc1 libgcrypt20 libglib2.0-0 libgmp-dev libgmp10 libgnutls-deb0-28 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed2 libidn11 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-2 libmysqlclient18 libncurses5 libnettle4 libp11-kit0 libpcre3 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libstdc++6 libtasn1-6 libtinfo5 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxml2-dev libxslt1-dev libxslt1.1 zlib1g zlib1g-dev
RUN bitnami-pkg install ruby-2.3.7-0 --checksum 0d0d83ab41cd677f2e662bf19c2cbb7e4f5cff66c086679abbde1247950b76aa
RUN bitnami-pkg install postgresql-client-9.6.9-0 --checksum d1aa2bfe19133954fd8ceffced34d4ade24502a3a3813a8f65e8bbbc2238d3a0
RUN bitnami-pkg install mysql-client-10.1.34-0 --checksum 2954d9390cb8b91dc924beacc179ed03050f6c5cb7ad328010cdbde1ab05c1e9
RUN bitnami-pkg install git-2.18.0-0 --checksum 107278388849d944d1f3cc305087e1a1c0b3a52801c112572664e91c44a12cdf
RUN bitnami-pkg unpack redmine-3.4.6-0 --checksum 40eb460e296f537813501aad49085ff1413def3fb060f237d5ca4b993ae600f7

COPY rootfs /
ENV BITNAMI_APP_NAME="redmine" \
    BITNAMI_IMAGE_VERSION="3.4.6-r17" \
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
