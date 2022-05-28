FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl ghostscript gsfonts gzip imagemagick libaudit1 libbsd0 libc6 libcap-ng0 libcom-err2 libcurl4 libedit2 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmariadb3 libncurses6 libnettle6 libnghttp2-14 libp11-kit0 libpam0g libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libssh2-1 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxslt1.1 procps sqlite3 tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.25.2-0" --checksum 3f8882ec1dcc0e9b50cdc848fb6e7bed7f0dd80caeef72d33c2209e9e80c2a9f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "3.0.4-0" --checksum 28a542e5a0cb321d91a712cafb95c6429acd0fde252e22a2f8fb28a23c066a45
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "11.16.0-0" --checksum d79676cf09b1852d4dd1d26c0643f09c67f9ed63f3895f21fa87cc65484a432a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.6.8-0" --checksum a288a3866c8d3b06951b6781c79a6e3551e99c159aafa1d3dfcaa3e54db93ea7
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.36.1-0" --checksum e00f740b66faf2808cb8983a39b186d43a8367730512c402df78751a9cefbfc1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "redmine" "5.0.1-0" --checksum 5b25040ae34e4eaf3e0f2bf0e8b50db248a49cfca2cf068c32e12bead3dbcfb5
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
RUN /opt/bitnami/scripts/redmine/postunpack.sh
ENV APP_VERSION="5.0.1" \
    BITNAMI_APP_NAME="redmine" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:$PATH"

EXPOSE 3000

USER root
ENTRYPOINT [ "/opt/bitnami/scripts/redmine/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/redmine/run.sh" ]
