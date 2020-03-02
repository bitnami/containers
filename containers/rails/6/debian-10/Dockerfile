FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/ruby/bin:/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:/opt/bitnami/rails/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl default-libmysqlclient-dev dirmngr ghostscript gnupg imagemagick libaudit1 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libjemalloc2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libncurses6 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpam0g libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libxml2-dev libxslt1-dev netcat-traditional procps sudo unzip zlib1g zlib1g-dev
RUN /build/bitnami-user.sh && \
    /build/install-nami.sh
RUN bitnami-pkg install ruby-2.6.5-1 --checksum 99d4bc115bd1f2ce13a76e16359f03acef2ceccfc5468f1b008e9ea9d07dc7fc
RUN bitnami-pkg install node-10.19.0-0 --checksum a91f35d97b8219efbe1ae9bc8eda0e0dafa84d738a8eaa0e0e15b599f4fbbff2
RUN bitnami-pkg install mysql-client-10.3.22-1 --checksum e9fa94f574c87d15f0b6aba7cff1c06f70c0e69c1c442378c9961fc148fa68ef
RUN bitnami-pkg install git-2.25.1-1 --checksum 6bd8fb21fa2f80f633043e3228043ccf855179d39f3bae90a7028e5725989479
RUN bitnami-pkg install rails-6.0.2-1-0 --checksum ba61d672b280ed3ca5670371453750a55bf92ddd333f243b74ef26d09c747cd2
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN mkdir /app && chown bitnami:bitnami /app
RUN /build/install-gosu.sh
RUN /build/install-tini.sh

COPY rootfs /
ENV BITNAMI_APP_NAME="rails" \
    BITNAMI_IMAGE_VERSION="6.0.2-1-debian-10-r33" \
    BUNDLE_BUILD__SASSC="--disable-march-tune-native" \
    RAILS_ENV="development"

EXPOSE 3000

WORKDIR /app
USER bitnami
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000" ]
