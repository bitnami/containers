FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl advancecomp ca-certificates curl file gifsicle gzip hostname imagemagick jhead jpegoptim libbrotli1 libbsd0 libbz2-1.0 libc6 libcom-err2 libcrypt1 libcurl4 libedit2 libffi7 libgcc-s1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed6 libicu67 libidn2-0 libjpeg-turbo-progs libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmd0 libncursesw6 libnettle8 libnghttp2-14 libnsl2 libp11-kit0 libpq5 libpsl5 libreadline-dev libreadline8 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libtirpc3 libunistring2 libuuid1 libxml2 libxslt1.1 optipng pngcrush pngquant procps rsync sqlite3 tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.13-164" --checksum 3908ffa59bfa43c84081a4803d79ac26ce1647f020ad97ffb264bdbcaa134163
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-153" --checksum d3ae0109be24e8bc56f97359b8290b91243454de946dd60bd8520a0896a88449
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.3-153" --checksum 8c8e324ab6e7b7d76b4655182d6ea5f6550edfc9e32bec92228e678c26fc8b16
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "2.7.6-152" --checksum e540186296667507c027334b500b6058952398e9b98c1e9ebd62f2b3775e61bc
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "13.7.0-152" --checksum c36c823d21ed1c114369c7335ffe72df1c53e57214861702a10fc290f7350e48
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.20.0-2" --checksum 127f7b97bd46468ce62bc5cd9868371ca2c4c1e7201f6271a309b34a17b97d90
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.37.1-2" --checksum cac709be5709568fc93602ec97f27c1ae02b6314980f3e046649a0ee30a801e6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "brotli" "1.0.9-152" --checksum a63e73736813c091efd0d20cd1f1bc0c1276a09b05dac609ee46ece34d223692
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "discourse" "2.8.7-2" --checksum cb3cca174a391ce5c96519308737c227ed856d29b253f286ad08c8966eabb811
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN /opt/bitnami/ruby/bin/gem install --force bundler -v '< 2'

COPY rootfs /
RUN /opt/bitnami/scripts/discourse/postunpack.sh
ENV APP_VERSION="2.8.7" \
    BITNAMI_APP_NAME="discourse" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/node/bin:/opt/bitnami/git/bin:/opt/bitnami/brotli/bin:$PATH"

EXPOSE 3000

USER root
ENTRYPOINT [ "/opt/bitnami/scripts/discourse/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/discourse/run.sh" ]
