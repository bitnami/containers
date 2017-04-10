FROM bitnami/minideb-extras:jessie-r13

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=redmine \
    BITNAMI_IMAGE_VERSION=3.3.3-r0 \
    PATH=/opt/bitnami/ruby/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:$PATH

# System packages required
RUN install_packages libc6 libssl1.0.0 zlib1g libreadline6 libncurses5 libtinfo5 libffi6 libxml2-dev zlib1g-dev libxslt1-dev libgmp-dev ghostscript imagemagick libmysqlclient18 libpq5 libstdc++6 libgcc1 libcurl3 libidn11 librtmp1 libssh2-1 libgssapi-krb5-2 libkrb5-3 libk5crypto3 libcomerr2 libldap-2.4-2 libgnutls-deb0-28 libhogweed2 libnettle4 libgmp10 libgcrypt20 libkrb5support0 libkeyutils1 libsasl2-2 libp11-kit0 libtasn1-6 libgpg-error0 libxml2 libxslt1.1 liblzma5 libmagickcore-6.q16-2 liblcms2-2 liblqr-1-0 libfftw3-double3 libfontconfig1 libfreetype6 libxext6 libx11-6 libbz2-1.0 libltdl7 libgomp1 libglib2.0-0 libexpat1 libpng12-0 libxcb1 libpcre3 libxau6 libxdmcp6

# Additional modules required
RUN bitnami-pkg install ruby-2.1.10-4 --checksum 205f8f287dec90b00d41cc3399280276a950ac4139c2937f97d937f6aca94630
RUN bitnami-pkg install mysql-client-10.1.22-3 --checksum 9e881a7c404f658c93abd665ecd1372f61a591d784e6456c64c0129358a7ff1a
RUN bitnami-pkg install git-2.10.1-2 --checksum 6f9fd8b0591f268f965930db0c091598e5c4f9dccbb6853010e1ac9e5035cd6f

# Install redmine
RUN bitnami-pkg unpack redmine-3.3.3-0 --checksum 6da37630bf47bec6e9f7641f3916fae4920c0eea3a503ada4975a409f5bb3f33

COPY rootfs /

ENV REDMINE_USERNAME=user \
    REDMINE_PASSWORD=bitnami1 \
    REDMINE_EMAIL=user@example.com \
    REDMINE_LANGUAGE=en \
    MARIADB_USER=root \
    MARIADB_HOST=mariadb \
    MARIADB_PORT=3306

VOLUME ["/bitnami/redmine"]

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["/run.sh"]
