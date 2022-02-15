FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl advancecomp ca-certificates curl file ghostscript gifsicle gzip hostname imagemagick jhead jpegoptim libbsd0 libbz2-1.0 libc6 libcom-err2 libcurl4 libedit2 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjpeg-turbo-progs libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncurses6 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxml2-dev libxslt1-dev libxslt1.1 optipng pngcrush pngquant procps rsync sqlite3 tar zlib1g zlib1g-dev
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.12-31" --checksum 48db897c12810ff5f17a323e9b4a0cc2812e673d66f94feb9d90e3abb28e664b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.1-7" --checksum 0ef01592ac0331fb1b486122aac3434cd103c3488652a871951a533037d277f8
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "uglify-js" "3.15.1-1" --checksum ddd433951c9ffc41e699157de03b548c11da20fa1ea33edcb6c133647dbf6402
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "2.7.5-31" --checksum f40614cc2979e08b3dce00c1196e6fbf1e075e0480f1f5a0d7b17278bab506c8
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "13.6.0-1" --checksum 7677c5c3187f00595393dfcbab89de5626d08cafd9888c19a5ef74ce6c361630
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.19.0-1" --checksum 400fb188f20ebb22fe9a99f6ef46598902884b9fbd87da481455cbc60273497d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.35.1-1" --checksum d6e13f2b43164f885489658fbd8b95c9a006064d3389093712b179315dbf265d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "brotli" "1.0.9-5" --checksum e969966d110dbfe93d23f65322a309f9db0ca214cb86c75063e66ae17acb303f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-4" --checksum ec62006ece7e0b49c65926e458ba2b71d6d251552118b1378840b1803dbb3d53
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "discourse" "2.7.13-1" --checksum f97a7e13b5b975f8143180fed8cbe7cfd60466ed95b86e53a97c32c330d05a6d
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN /opt/bitnami/ruby/bin/gem install --force bundler -v '< 2'

COPY rootfs /
RUN /opt/bitnami/scripts/discourse/postunpack.sh
ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="2.7.13-debian-10-r23" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/node/bin:/opt/bitnami/git/bin:/opt/bitnami/brotli/bin:$PATH"

EXPOSE 3000

USER root
ENTRYPOINT [ "/opt/bitnami/scripts/discourse/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/discourse/run.sh" ]
