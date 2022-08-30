FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="5.0.2-debian-11-r24" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/redmine" \
      org.opencontainers.image.title="redmine" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="5.0.2"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl ghostscript git gsfonts gzip imagemagick libaudit1 libbsd0 libc6 libcap-ng0 libcom-err2 libcrypt1 libedit2 libffi7 libgcc-s1 libgmp10 libgnutls30 libgssapi-krb5-2 libhogweed6 libicu67 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmariadb3 libmd0 libncurses6 libnettle8 libp11-kit0 libpam0g libpq5 libreadline-dev libreadline8 libsasl2-2 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxslt1.1 procps sqlite3 tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.27.3-0" --checksum 1aa32d853f4ba273642dc4bb9fb50146434f2c44978d02e1728f72a047e50567
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "3.0.4-153" --checksum a0c64312075dfe1364bd5fc6fc290aef5c54707abe1a0a78877418aa79723914
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "11.17.0-1" --checksum d34624cbd7e1905269ad7d873efe3cad0687bcf52dd822c84ad70c61bca180de
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.6.9-1" --checksum 14ae2f6d8d5f4e3a9e4cf62d5a3da80587a20651a5920dbc4ac89afdaf06f8c0
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "redmine" "5.0.2-3" --checksum ec89d1d6f73e06dd3c282a083c90cdd20d37a0d3e98c3fb587e0b6261765cb6e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-154" --checksum e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
RUN /opt/bitnami/scripts/redmine/postunpack.sh
ENV APP_VERSION="5.0.2" \
    BITNAMI_APP_NAME="redmine" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/mysql/bin:$PATH"

EXPOSE 3000

USER root
ENTRYPOINT [ "/opt/bitnami/scripts/redmine/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/redmine/run.sh" ]
