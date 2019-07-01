FROM bitnami/minideb-extras:stretch-r407
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbsd0 libbz2-1.0 libc6 libcomerr2 libcurl3 libedit2 libexpat1 libffi6 libfftw3-double3 libfontconfig1 libfreetype6 libgcc1 libgcrypt20 libglib2.0-0 libgmp-dev libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-3 libmagickwand-6.q16-3 libmariadbclient18 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libtasn1-6 libtinfo5 libunistring0 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxml2-dev libxslt1-dev libxslt1.1 zlib1g zlib1g-dev
RUN bitnami-pkg install ruby-2.6.3-0 --checksum 522af3dfc94655fe0858f27bcfb5304eafebab573aabe03154e72477844763b8
RUN bitnami-pkg install postgresql-client-11.4.0-0 --checksum 39c430fe23aef65ef26ca6f3cdd3758991ab25dff5e5c3bc2e4864d7b23ce2d3
RUN bitnami-pkg install mysql-client-10.3.16-0 --checksum c22e014b6fc259a67fcdd52b365e62ed08e6d7e6871888d9ef935c8531ada9b2
RUN bitnami-pkg install git-2.22.0-0 --checksum efa83383130dac1a51b192acdec4868d5d2593385efece42fdb5c52525583b55
RUN bitnami-pkg unpack redmine-4.0.4-0 --checksum df7603446384457a9b70715e2ed5cfcad16df6c419c39ec9927a5fb7cc5424a1

COPY rootfs /
ENV BITNAMI_APP_NAME="redmine" \
    BITNAMI_IMAGE_VERSION="4.0.4-debian-9-r21" \
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

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
