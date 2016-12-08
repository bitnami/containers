FROM gcr.io/stacksmith-images/minideb:jessie-r5

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=discourse \
    BITNAMI_IMAGE_VERSION=1.6.7-r1 \
    PATH=/opt/bitnami/ruby/bin:/opt/bitnami/postgresql-client/bin:/opt/bitnami/git/bin:$PATH

# System packages required
RUN install_packages zlib1g libssl1.0.0 libc6 libcurl3 libidn11 librtmp1 libssh2-1 libgssapi-krb5-2 libkrb5-3 libk5crypto3 libcomerr2 libldap-2.4-2 libgnutls-deb0-28 libhogweed2 libnettle4 libgmp10 libgcrypt20 libkrb5support0 libkeyutils1 libsasl2-2 libp11-kit0 libtasn1-6 libgpg-error0 libffi6 libxslt1.1 libxml2 liblzma5 libedit2 libbsd0 libtinfo5 libreadline6 libncurses5 libxml2-dev zlib1g-dev libxslt1-dev libgmp-dev ghostscript imagemagick libmysqlclient18 libpq5 libstdc++6 libgcc1

# Additional modules required
RUN bitnami-pkg install git-2.10.1-1 --checksum 454e9eb6fb781c8d492f9937439dcdfc1a931959d948d4c70e79716d2ea51a2b
RUN bitnami-pkg install postgresql-client-9.6.1-1 --checksum 9a793e2413490cdf5f9fdd1e9923f7a30ee196b5348a11583c1a4136893f39f8
RUN bitnami-pkg install ruby-2.3.3-1 --checksum 107c8f5e76b77a351cfb7e3e544f9b86b8633eae563f179349137cab70b8d841

# Install discourse
RUN bitnami-pkg unpack discourse-1.6.7-1 --checksum 72f55b76cc4c3e591d7309c18e837efaaae5a3620321541d8b8322bdc534191c

COPY rootfs /

VOLUME ["/bitnami/discourse"]

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami","start","--foreground","discourse"]
