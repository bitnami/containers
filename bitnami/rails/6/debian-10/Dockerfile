FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl ghostscript gzip imagemagick libaudit1 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjemalloc2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmariadb3 libncurses6 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpam0g libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libxml2 libxml2-dev libxslt1-dev procps sqlite3 sudo tar zlib1g zlib1g-dev
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.12-31" --checksum 48db897c12810ff5f17a323e9b4a0cc2812e673d66f94feb9d90e3abb28e664b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "2.6.9-6" --checksum 3f2f379b4f03398186ff726649ebb043821fb5c70673edb4b6b902bf8a8d4baf
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.19.0-1" --checksum 400fb188f20ebb22fe9a99f6ef46598902884b9fbd87da481455cbc60273497d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.3.32-31" --checksum 4489feca3a65fbd733774d193b02914187451c6edf27855ebc5756e45a9f299e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.35.1-1" --checksum d6e13f2b43164f885489658fbd8b95c9a006064d3389093712b179315dbf265d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.1-7" --checksum 0ef01592ac0331fb1b486122aac3434cd103c3488652a871951a533037d277f8
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "rails" "6.1.4-6-0" --checksum 61230d7a0743736a96017e1735ab416a63d3f634ebf0cf22e7783cc31cecc4e1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-4" --checksum ec62006ece7e0b49c65926e458ba2b71d6d251552118b1378840b1803dbb3d53
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/bitnami-user.sh

COPY rootfs /
RUN /opt/bitnami/scripts/rails/postunpack.sh
ENV BITNAMI_APP_NAME="rails" \
    BITNAMI_IMAGE_VERSION="6.1.4-6-debian-10-r1" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/ruby/bin:/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 3000

WORKDIR /app
ENTRYPOINT [ "/opt/bitnami/scripts/rails/entrypoint.sh" ]
CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000" ]
