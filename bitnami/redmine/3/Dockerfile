FROM bitnami/minideb-extras:jessie-r15
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbsd0 libbz2-1.0 libc6 libcomerr2 libcurl3 libedit2 libexpat1 libffi6 libfftw3-double3 libfontconfig1 libfreetype6 libgcc1 libgcrypt20 libglib2.0-0 libgmp-dev libgmp10 libgnutls-deb0-28 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed2 libidn11 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-2 libmysqlclient18 libncurses5 libnettle4 libp11-kit0 libpcre3 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libstdc++6 libtasn1-6 libtinfo5 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxml2-dev libxslt1-dev libxslt1.1 zlib1g zlib1g-dev
RUN bitnami-pkg install ruby-2.1.10-4 --checksum 205f8f287dec90b00d41cc3399280276a950ac4139c2937f97d937f6aca94630
RUN bitnami-pkg install postgresql-client-9.6.2-2 --checksum 1cb6a386042968d222f6f2dc6ba44ec973c4926e941aee14862e6cfed4bb9834
RUN bitnami-pkg install mysql-client-10.1.23-0 --checksum 9c38e41f237a4b9ce1aca7b9ecad86be5c55b924880cef45b87d635a4aea9d3d
RUN bitnami-pkg install git-2.10.1-2 --checksum 6f9fd8b0591f268f965930db0c091598e5c4f9dccbb6853010e1ac9e5035cd6f
RUN bitnami-pkg unpack redmine-3.3.3-1 --checksum c4fcb5513c8a101cc39cd125264d75b1e4941ae84bb10d3811d71691c3db830d

COPY rootfs /

ENV BITNAMI_APP_NAME="redmine" \
    BITNAMI_IMAGE_VERSION="3.3.3-r2" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/postgresql-client/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:$PATH" \
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

VOLUME ["/bitnami/redmine"]

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
