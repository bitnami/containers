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
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.1-5" --checksum 1e34030c18f0ec2467fa5f1b1fbad24add217f671c3a61628f7b8671391f9676
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "uglify-js" "3.14.5-3" --checksum fe76098f3380a24d8076a023e0adf5b68eab7f6ed764a5b60979465e685c2d45
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "2.7.5-3" --checksum 37133876204e89d7612320e80ce4a9b63d29fa7cc061dacbac2d535955e5de79
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "13.5.0-1" --checksum f0b3010943243515cfa8249978f690cb6c9e79b91f1aeafe9a3abc59321d43af
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.18.3-5" --checksum 70338565b39f0c8be869cb05107365dac31a26caf1fe5ba24de171a6dd334375
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.34.1-3" --checksum fd50ae3e5db7e54d4e3168aebc7d0fe037fc975ae3611c97e0abcbbcc503b2e8
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "brotli" "1.0.9-3" --checksum c1479ca79a6396d7b6bce69e28bd9352cafeb99341bcc17454dc7296b4cd7ac1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-2" --checksum 7419bc5e2be68eb14c92e321acc843413481cda73323fb8c0d1dda8b1e5aa9d5
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "discourse" "2.7.13-1" --checksum f97a7e13b5b975f8143180fed8cbe7cfd60466ed95b86e53a97c32c330d05a6d
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN /opt/bitnami/ruby/bin/gem install --force bundler -v '< 2'

COPY rootfs /
RUN /opt/bitnami/scripts/discourse/postunpack.sh
ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="2.7.13-debian-10-r5" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/node/bin:/opt/bitnami/git/bin:/opt/bitnami/brotli/bin:$PATH"

EXPOSE 3000

USER root
ENTRYPOINT [ "/opt/bitnami/scripts/discourse/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/discourse/run.sh" ]
