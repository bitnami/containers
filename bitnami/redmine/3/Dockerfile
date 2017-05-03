FROM bitnami/minideb-extras:jessie-r14
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME="redmine" \
    BITNAMI_IMAGE_VERSION="3.3.3-r1" \
    MARIADB_HOST="mariadb" \
    MARIADB_PASSWORD="" \
    MARIADB_PORT="3306" \
    MARIADB_USER="root" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:$PATH" \
    REDMINE_EMAIL="user@example.com" \
    REDMINE_LANGUAGE="en" \
    REDMINE_PASSWORD="bitnami1" \
    REDMINE_USERNAME="user" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_TLS="true" \
    SMTP_USER=""

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfftw3-double3 libfontconfig1 libfreetype6 libgcc1 libgcrypt20 libglib2.0-0 libgmp-dev libgmp10 libgnutls-deb0-28 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed2 libidn11 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-2 libmysqlclient18 libncurses5 libnettle4 libp11-kit0 libpcre3 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libstdc++6 libtasn1-6 libtinfo5 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxml2-dev libxslt1-dev libxslt1.1 zlib1g zlib1g-dev
RUN bitnami-pkg install ruby-2.1.10-4 --checksum 205f8f287dec90b00d41cc3399280276a950ac4139c2937f97d937f6aca94630
RUN bitnami-pkg install mysql-client-10.1.22-3 --checksum 9e881a7c404f658c93abd665ecd1372f61a591d784e6456c64c0129358a7ff1a
RUN bitnami-pkg install git-2.10.1-2 --checksum 6f9fd8b0591f268f965930db0c091598e5c4f9dccbb6853010e1ac9e5035cd6f
RUN bitnami-pkg unpack redmine-3.3.3-0 --checksum 6da37630bf47bec6e9f7641f3916fae4920c0eea3a503ada4975a409f5bb3f33

COPY rootfs /

VOLUME ["/bitnami/redmine"]

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
