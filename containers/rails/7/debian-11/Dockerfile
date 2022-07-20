FROM docker.io/bitnami/minideb:bullseye
ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libaudit1 libbrotli1 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcrypt1 libcurl4 libffi7 libgcc-s1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed6 libicu67 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmariadb3 libncurses6 libncursesw6 libnettle8 libnghttp2-14 libnsl2 libp11-kit0 libpam0g libpq5 libpsl5 libreadline-dev libreadline8 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libtirpc3 libunistring2 libxml2 procps sqlite3 sudo tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.13-151" --checksum 1b28fa915312f8c1fc5b4a1a4381c06ffc599e9cc1331b500c8fd012e96ba6f0
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-150" --checksum da4a2f759ccc57c100d795b71ab297f48b31c4dd7578d773d963bbd49c42bd7b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "2.7.6-150" --checksum 4517967d38c836fa718978c1cd8527c4f22fbda7b06c81f7d78c5435a983a49f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.19.3-150" --checksum 97cffecfb637e5758197e4eb14d50b42048768eba242da4b534f1d8bacbd6958
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.6.8-150" --checksum b47e1015fc1c9ce456f134ffd5b6ac6960c3f369c96fcd37319e9289b29a1047
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.36.1-151" --checksum a7adf946a3e5d1b7e9f18abd4bbf112780a41ea797bdd3f067f87dfea07e85d6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.3-150" --checksum 1013e2ebbe58e5dc8f3c79fc952f020fc5306ba48463803cacfbed7779173924
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "rails" "7.0.3-0-150" --checksum 31f61b3eb5e023b6ec9feb7638e63fd5d2416283b305a2c94ea37e316c14fe79
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/bitnami-user.sh

COPY rootfs /
RUN /opt/bitnami/scripts/rails/postunpack.sh
ENV APP_VERSION="7.0.3-0" \
    BITNAMI_APP_NAME="rails" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:/opt/bitnami/ruby/bin:/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:$PATH"

EXPOSE 3000

WORKDIR /app
ENTRYPOINT [ "/opt/bitnami/scripts/rails/entrypoint.sh" ]
CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000" ]
