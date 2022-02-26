FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl ghostscript gsfonts gzip imagemagick libaudit1 libbsd0 libc6 libcap-ng0 libcom-err2 libcurl4 libedit2 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjemalloc2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmariadb3 libncurses6 libnettle6 libnghttp2-14 libp11-kit0 libpam0g libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libssh2-1 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxslt1.1 procps sqlite3 tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.20.2-0" --checksum cf127534dd75da82d58377bfd0d84f47fe1760830336a44365372805e48fe343
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "2.6.9-9" --checksum 6e65b0783358aee1dccf51c84874bba0a3a3a66f14d5d284ec94dba06a9fc510
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "11.15.0-3" --checksum fae1edf328c918adde434d051a85128964bc696d3bf8e8bb25097792ffa4ac24
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.4.24-3" --checksum 80bf46b728b91a708f223819ce789ad3f81f9c6b38878e8f547a46356cbfa0a6
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
    BITNAMI_IMAGE_VERSION="4.2.3-debian-10-r131" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:$PATH"

EXPOSE 3000

USER root
ENTRYPOINT [ "/opt/bitnami/scripts/redmine/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/redmine/run.sh" ]
