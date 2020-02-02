FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/ruby/bin:/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:/opt/bitnami/rails/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl default-libmysqlclient-dev dirmngr ghostscript gnupg imagemagick libbz2-1.0 libc6 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libncurses6 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libxml2-dev libxslt1-dev netcat-traditional procps sudo unzip zlib1g zlib1g-dev
RUN /build/bitnami-user.sh && \
    /build/install-nami.sh
RUN bitnami-pkg install ruby-2.6.5-1 --checksum 99d4bc115bd1f2ce13a76e16359f03acef2ceccfc5468f1b008e9ea9d07dc7fc
RUN bitnami-pkg install node-10.18.1-0 --checksum 16a8470725407d4f9262681a284e7eb3241600d414a13458fb635ab983bd09ff
RUN bitnami-pkg install mysql-client-10.3.22-0 --checksum 9529ac5187264223e3852602f7d9a51ed0b2547bbed99f3d05f3b7fa20adf57f
RUN bitnami-pkg install git-2.25.0-0 --checksum 392bea1a8c3607f8ebce5403ec22819915ab8a5cc2245a5249568660b4ed07df
RUN bitnami-pkg install rails-6.0.2-1-0 --checksum ba61d672b280ed3ca5670371453750a55bf92ddd333f243b74ef26d09c747cd2
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN mkdir /app && chown bitnami:bitnami /app
RUN /build/install-gosu.sh
RUN /build/install-tini.sh

COPY rootfs /
ENV BITNAMI_APP_NAME="rails" \
    BITNAMI_IMAGE_VERSION="6.0.2-1-debian-10-r7" \
    BUNDLE_BUILD__SASSC="--disable-march-tune-native" \
    RAILS_ENV="development"

EXPOSE 3000

WORKDIR /app
USER bitnami
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000" ]
