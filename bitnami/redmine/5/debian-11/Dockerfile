FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="5.0.2-debian-11-r23" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/redmine" \
      org.opencontainers.image.title="redmine" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="5.0.2"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl ghostscript git gsfonts gzip imagemagick libaudit1 libbsd0 libc6 libcap-ng0 libcom-err2 libcrypt1 libedit2 libffi7 libgcc-s1 libgmp10 libgnutls30 libgssapi-krb5-2 libhogweed6 libicu67 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmariadb3 libmd0 libncurses6 libnettle8 libp11-kit0 libpam0g libpq5 libreadline-dev libreadline8 libsasl2-2 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxslt1.1 procps sqlite3 tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.27.2-1" --checksum 44d0058c0fffa1ccc89c081ed3e5c897489fa02580a839cfe1d37b2ca771f237
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "3.0.4-152" --checksum 31c2f63de32635f535f7ae9e382dc06e63b96532f26cf26121d63559628d317d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "11.17.0-0" --checksum 6fc185dfa4cac2f2338d9900835f74b94f023cf53c99edf0966ee0f66b43ed2b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.6.9-0" --checksum cebce7505cdf9a25aa92950d2d0b4f6678905c2c1aa4ade97d69b01b2848a266
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "redmine" "5.0.2-3" --checksum ec89d1d6f73e06dd3c282a083c90cdd20d37a0d3e98c3fb587e0b6261765cb6e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-153" --checksum d3ae0109be24e8bc56f97359b8290b91243454de946dd60bd8520a0896a88449
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
