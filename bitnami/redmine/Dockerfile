FROM gcr.io/stacksmith-images/minideb:jessie-r5

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=redmine \
    BITNAMI_IMAGE_VERSION=3.3.1-r8 \
    PATH=/opt/bitnami/ruby/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:$PATH

# System packages required
RUN install_packages --no-install-recommends libc6 libssl1.0.0 zlib1g libreadline6 libncurses5 libtinfo5 libffi6 libxml2-dev zlib1g-dev libxslt1-dev libgmp-dev ghostscript imagemagick libmysqlclient18 libpq5 libstdc++6 libgcc1 libcurl3 libidn11 librtmp1 libssh2-1 libgssapi-krb5-2 libkrb5-3 libk5crypto3 libcomerr2 libldap-2.4-2 libgnutls-deb0-28 libhogweed2 libnettle4 libgmp10 libgcrypt20 libkrb5support0 libkeyutils1 libsasl2-2 libp11-kit0 libtasn1-6 libgpg-error0 libxml2 libxslt1.1 liblzma5 libmagickcore-6.q16-2 liblcms2-2 liblqr-1-0 libfftw3-double3 libfontconfig1 libfreetype6 libxext6 libx11-6 libbz2-1.0 libltdl7 libgomp1 libglib2.0-0 libexpat1 libpng12-0 libxcb1 libpcre3 libxau6 libxdmcp6

# Additional modules required
RUN bitnami-pkg install ruby-2.1.10-3 --checksum e435ba6e622a94810bd320597e8bcb4c4e5866404b7fa41dc6addd2f6961d3e4
RUN bitnami-pkg install mysql-client-10.1.19-1 --checksum 2d946c8ee3e2e845f68a5cf3751d6477d88af194d263842797fe50a44414a173
RUN bitnami-pkg install git-2.10.1-1 --checksum 454e9eb6fb781c8d492f9937439dcdfc1a931959d948d4c70e79716d2ea51a2b

# Install redmine
RUN bitnami-pkg unpack redmine-3.3.1-6 --checksum 229679e8f6fd11f478aebdb52d124ba40e5546c65d0092e993f998da45ff74be

COPY rootfs /

VOLUME ["/bitnami/redmine"]

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "redmine"]
