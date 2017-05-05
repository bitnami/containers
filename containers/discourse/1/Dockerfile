FROM bitnami/minideb-extras:jessie-r15

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=discourse \
    BITNAMI_IMAGE_VERSION=1.7.8-r2 \
    PATH=/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/git/bin:$PATH

# System packages required
RUN install_packages zlib1g libssl1.0.0 libc6 libcurl3 libidn11 librtmp1 libssh2-1 libgssapi-krb5-2 libkrb5-3 libk5crypto3 libcomerr2 libldap-2.4-2 libgnutls-deb0-28 libhogweed2 libnettle4 libgmp10 libgcrypt20 libkrb5support0 libkeyutils1 libsasl2-2 libp11-kit0 libtasn1-6 libgpg-error0 libffi6 libxslt1.1 libxml2 liblzma5 libedit2 libbsd0 libtinfo5 imagemagick sendmail libreadline6 libncurses5 libxml2-dev zlib1g-dev libxslt1-dev libgmp-dev ghostscript libmysqlclient18 libpq5 libstdc++6 libgcc1

# Additional modules required
RUN bitnami-pkg install git-2.10.1-2 --checksum 6f9fd8b0591f268f965930db0c091598e5c4f9dccbb6853010e1ac9e5035cd6f
RUN bitnami-pkg unpack postgresql-client-9.6.2-2 --checksum 1cb6a386042968d222f6f2dc6ba44ec973c4926e941aee14862e6cfed4bb9834
RUN bitnami-pkg unpack discourse-sidekiq-1.7.8-1 --checksum 970584c2d3c8de27734b9beb4899c4c814968f44971bfd010ef7761092dfdec5
RUN bitnami-pkg install ruby-2.3.4-0 --checksum 92d6db7a6ba0893334e9d1d46a66a7459df08e151762f87942d6b0f29db0171a

# Install discourse
RUN bitnami-pkg unpack discourse-1.7.8-1 --checksum 231f37f7dae593b20a0a24fd316a416fcfc1c1442c2dbed70cb74feb8dd2047b

COPY rootfs /

ENV DISCOURSE_USERNAME="user" \
    DISCOURSE_PASSWORD="bitnami" \
    DISCOURSE_EMAIL="user@example.com" \
    POSTGRES_USER="postgres" \
    POSTGRES_MASTER_HOST="postgresql" \
    REDIS_MASTER_HOST="redis" \
    POSTGRESQL_USERNAME="bn_discourse" \
    POSTGRESQL_USERPASSWORD="bitnami1" \
    POSTGRESQL_DATABASE="bitnami_application"

VOLUME ["/bitnami/discourse"]

VOLUME ["/bitnami/discourse-sidekiq"]

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami","start","--foreground","discourse"]
