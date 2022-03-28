FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl ghostscript gsfonts gzip imagemagick libaudit1 libbsd0 libc6 libcap-ng0 libcom-err2 libcurl4 libedit2 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjemalloc2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmariadb3 libncurses6 libnettle6 libnghttp2-14 libp11-kit0 libpam0g libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libssh2-1 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxslt1.1 procps sqlite3 tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.24.2-0" --checksum 6671445790516400883182abf5e957645260585b8a9f9432a8a6b63b045b6559
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "2.6.9-10" --checksum 37a9d22bbe245e2cb1123a9ca6bc7cb267d6d3ff11e1ec04fdaedfe91b3dbd01
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "11.15.0-4" --checksum f641b12e9ac577e4139708247a590b09683ab8cbcdf665b99f596df68ae9dbc1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.4.24-4" --checksum 68f045125759c5b130a9cede306e8e2479e85b3bfd2414592a630a085e977b09
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.35.1-6" --checksum 75c0294b7af868721549926139e6ddbec9548fbd0e69c7e199d640a4531d858b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "redmine" "4.2.5-0" --checksum a645631406df6a741fe78974ddbb5fb642246db4282e95c6e11c9023e760ff27
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
RUN /opt/bitnami/scripts/redmine/postunpack.sh
ENV APP_VERSION="4.2.5" \
    BITNAMI_APP_NAME="redmine" \
    BITNAMI_IMAGE_VERSION="4.2.5-debian-10-r0" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:$PATH"

EXPOSE 3000

USER root
ENTRYPOINT [ "/opt/bitnami/scripts/redmine/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/redmine/run.sh" ]
