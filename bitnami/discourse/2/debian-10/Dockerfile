FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl advancecomp ca-certificates curl file gifsicle gzip hostname imagemagick jhead jpegoptim libbsd0 libbz2-1.0 libc6 libcom-err2 libcurl4 libedit2 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjpeg-turbo-progs libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncurses6 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxslt1.1 optipng pngcrush pngquant procps rsync sqlite3 tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.12-37" --checksum 3272da2099afdae735a7d3fb199e83f3bd74b44ebf6953e2f9a3dd0ad45091d1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.1-10" --checksum 35c818ba3f4b5aae905959bc7d3a5e81fc63786e3c662b604612c0aa7fcda8fd
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "uglify-js" "3.15.2-1" --checksum 63173af1fbe2e7dabca039909facf71200aa74ea9f464fabc7a1114fe96248de
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "2.7.5-35" --checksum 98d92c65fc296f915a23ee5893fab07177f02274ec33887fb2e080c02e401dd4
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "13.6.0-4" --checksum 10c4c8870775aa837cc37c243b20cde2efd166482aab0df90974c105884ea210
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.19.0-4" --checksum 0649af9ad2856d01d574146b62c840d3a330f2e85227a2ae73ec6500737ccccc
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.35.1-5" --checksum da12ba7cebb03c4eb983ba2248daf0ed5399be1bd8fa9d2d3931614ce6079ff6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "brotli" "1.0.9-8" --checksum a9e53945655ab217802f413378f82a93c20a624a52495a52eb853cb945309e0e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "discourse" "2.7.13-1" --checksum f97a7e13b5b975f8143180fed8cbe7cfd60466ed95b86e53a97c32c330d05a6d
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN /opt/bitnami/ruby/bin/gem install --force bundler -v '< 2'

COPY rootfs /
RUN /opt/bitnami/scripts/discourse/postunpack.sh
ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="2.7.13-debian-10-r32" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/node/bin:/opt/bitnami/git/bin:/opt/bitnami/brotli/bin:$PATH"

EXPOSE 3000

USER root
ENTRYPOINT [ "/opt/bitnami/scripts/discourse/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/discourse/run.sh" ]
