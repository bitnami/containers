FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl ghostscript gzip imagemagick libaudit1 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjemalloc2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmariadb3 libncurses6 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpam0g libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libxml2 libxml2-dev libxslt1-dev procps sqlite3 sudo tar zlib1g zlib1g-dev
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.12-32" --checksum 0649a1688896cf6ee9a9fd4d554ac33f364f498fca6d8be67a95f8111e7dad4f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "2.6.9-7" --checksum e02d967e42ddbafdcf871527051ef50a7828cdc0e316bf301d3e143abbea774a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.19.0-2" --checksum d1c0e36b98ba6464fcf517c50d35d212d8bf7626cd99838f361bbe1c47319e5e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.3.34-1" --checksum e4111d4f7ed30cafbf80e97f6fae69787445517a7a18c5a0dcca23360cf185ae
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.35.1-3" --checksum e5feed054f6c6e0497502e5c0551070241f543966491e962ce1f51780f6b170e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.1-8" --checksum 4b509978f6d0a4c3b958deeb3490241cda60e4412c138da665192631d60f70de
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "rails" "6.1.4-6-1" --checksum 6b0f343337ee3f423ea247374379e1f99d12336c71e09c42d66de883df019d39
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-5" --checksum 6f8fd2267481ffbe899a7f93b7b3076cd78dd70b7b9835bed79414932a749664
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/bitnami-user.sh

COPY rootfs /
RUN /opt/bitnami/scripts/rails/postunpack.sh
ENV BITNAMI_APP_NAME="rails" \
    BITNAMI_IMAGE_VERSION="6.1.4-6-debian-10-r5" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/ruby/bin:/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 3000

WORKDIR /app
ENTRYPOINT [ "/opt/bitnami/scripts/rails/entrypoint.sh" ]
CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000" ]
