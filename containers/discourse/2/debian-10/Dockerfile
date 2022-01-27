FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl advancecomp ca-certificates curl file ghostscript gifsicle gzip hostname imagemagick jhead jpegoptim libbsd0 libbz2-1.0 libc6 libcom-err2 libcurl4 libedit2 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjpeg-turbo-progs libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncurses6 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxml2-dev libxslt1-dev libxslt1.1 optipng pngcrush pngquant procps rsync sqlite3 tar zlib1g zlib1g-dev
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.12-12" --checksum c081f7f9663d4d64e7f26d6e6a77b3860ee1f39c309bd564f801c39192042d2f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.1-6" --checksum 845ff207415b5730cadd45aa3c757ca45a5c9e73bc54c24aa481ddca24eec35d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "uglify-js" "3.15.0-0" --checksum 3c2369bf6ba2d693b8a9826b9d70e03e84742f15e88a0749b723ee390aa098d0
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "2.7.5-3" --checksum 37133876204e89d7612320e80ce4a9b63d29fa7cc061dacbac2d535955e5de79
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "13.5.0-1" --checksum f0b3010943243515cfa8249978f690cb6c9e79b91f1aeafe9a3abc59321d43af
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.18.3-6" --checksum a529a3386f396110186951a0a4a4e1f440440d627041589635f69dbf0bdac116
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.35.0-0" --checksum 51075db42727d7b14b9941e7d7c063a135e9ad60cc606676d6e817e7d4a607b9
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "brotli" "1.0.9-4" --checksum 8e1ab973a3daba6106c19d25c8f0d99ab42160a525762ac4457b2aae247eff73
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-3" --checksum 276ab5a0be4b05e136ec468d62c8f9cc4f40d9664c55f01f16a9f1209ba16980
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "discourse" "2.7.13-1" --checksum f97a7e13b5b975f8143180fed8cbe7cfd60466ed95b86e53a97c32c330d05a6d
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN /opt/bitnami/ruby/bin/gem install --force bundler -v '< 2'

COPY rootfs /
RUN /opt/bitnami/scripts/discourse/postunpack.sh
ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="2.7.13-debian-10-r9" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/node/bin:/opt/bitnami/git/bin:/opt/bitnami/brotli/bin:$PATH"

EXPOSE 3000

USER root
ENTRYPOINT [ "/opt/bitnami/scripts/discourse/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/discourse/run.sh" ]
