FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl ghostscript gsfonts gzip imagemagick libaudit1 libbsd0 libc6 libcap-ng0 libcom-err2 libcurl4 libedit2 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjemalloc2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmariadb3 libncurses6 libnettle6 libnghttp2-14 libp11-kit0 libpam0g libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libssh2-1 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxml2-dev libxslt1-dev libxslt1.1 procps sqlite3 tar zlib1g zlib1g-dev
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.20.1-2" --checksum 5a5d183286140781203d11d468d4f84371c5808ee86471c7ee445f8d3cef0eb6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "2.6.9-8" --checksum e02d967e42ddbafdcf871527051ef50a7828cdc0e316bf301d3e143abbea774a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "11.15.0-3" --checksum fae1edf328c918adde434d051a85128964bc696d3bf8e8bb25097792ffa4ac24
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.4.24-2" --checksum 8288beee2fdd5a1421d45d9d823bc181b7350ee4eb54d91522fc0b4d2a370ceb
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.35.1-4" --checksum e5feed054f6c6e0497502e5c0551070241f543966491e962ce1f51780f6b170e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "redmine" "4.2.3-6" --checksum 0f038e35be207a53835d9e2296ba6d1457fd154a8c970eba1cc9147e32b9b7cc
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-6" --checksum 6f8fd2267481ffbe899a7f93b7b3076cd78dd70b7b9835bed79414932a749664
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
RUN /opt/bitnami/scripts/redmine/postunpack.sh
ENV BITNAMI_APP_NAME="redmine" \
    BITNAMI_IMAGE_VERSION="4.2.3-debian-10-r124" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:$PATH"

EXPOSE 3000

USER root
ENTRYPOINT [ "/opt/bitnami/scripts/redmine/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/redmine/run.sh" ]
