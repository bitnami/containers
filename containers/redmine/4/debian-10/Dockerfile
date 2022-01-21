FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl ghostscript gsfonts gzip imagemagick libaudit1 libbsd0 libc6 libcap-ng0 libcom-err2 libcurl4 libedit2 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjemalloc2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmariadb3 libncurses6 libnettle6 libnghttp2-14 libp11-kit0 libpam0g libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libssh2-1 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxml2-dev libxslt1-dev libxslt1.1 procps sqlite3 tar zlib1g zlib1g-dev
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.16.2-3" --checksum 57c13527238449d93bf5484e486da35f2306ca06db769bc5ac5609ec4fc2ef60
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "2.6.9-2" --checksum f8f60b6c685ff8cd5b7e7f2e9fcd87e9ec6021e9d6dda1d6d829a23a0f2d5c0e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "11.14.0-2" --checksum d3359325d864badb385c99ce52a4f4dd1a8a1630f9fb9907ef1545919e0ea058
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.4.22-1" --checksum 37ba718ad68506a9ea0705c12f013a6afc7210c82460769ffba0f16759caae95
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.34.1-2" --checksum c6f5511335c6ea2e98cb02cefc77a67aae6e570a0a15229ab620414d0278525a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "redmine" "4.2.3-2" --checksum ae058923199d956368e82fadc0a787a922625f464f1a8b7f4657c1c9b647caa3
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-2" --checksum 7419bc5e2be68eb14c92e321acc843413481cda73323fb8c0d1dda8b1e5aa9d5
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
RUN /opt/bitnami/scripts/redmine/postunpack.sh
ENV BITNAMI_APP_NAME="redmine" \
    BITNAMI_IMAGE_VERSION="4.2.3-debian-10-r94" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:$PATH"

EXPOSE 3000

USER root
ENTRYPOINT [ "/opt/bitnami/scripts/redmine/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/redmine/run.sh" ]
