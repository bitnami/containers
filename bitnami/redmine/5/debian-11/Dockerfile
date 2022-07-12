FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl ghostscript gsfonts gzip imagemagick libaudit1 libbrotli1 libbsd0 libc6 libcap-ng0 libcom-err2 libcrypt1 libcurl4 libedit2 libffi7 libgcc-s1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed6 libicu67 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmariadb3 libmd0 libncurses6 libnettle8 libnghttp2-14 libp11-kit0 libpam0g libpq5 libpsl5 libreadline-dev libreadline8 librtmp1 libsasl2-2 libssh2-1 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxslt1.1 procps sqlite3 tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-151" --checksum 089bb11a3bc6031c5a91ab5f9534e9e7e41b928d10d72a3986f16bb61d3a9900
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.25.3-2" --checksum 84ce4016efca8b6a6713d69e9d7c19003d4a530f8b420fb8cdcaa9cf9af47ee6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "3.0.4-150" --checksum 32f5d26a1d7c39521a33c0bbe6b47fe584d8f44d26a79fbe008ebb191d100821
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "11.16.0-150" --checksum 1204401fc614c448f61983e4bc1136b9ba0475c77b2f3ff497ffea59c2879a01
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.6.8-150" --checksum b47e1015fc1c9ce456f134ffd5b6ac6960c3f369c96fcd37319e9289b29a1047
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.37.0-0" --checksum 75341efddd4113ca16df9815f6e015881c73f71c66c412a43e2ed7cc4fa7f177
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "redmine" "5.0.2-0" --checksum 1c19c583e18ee7c17bea13506080200a2440c5a734e2a68f468da4406851b9ad
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
RUN /opt/bitnami/scripts/redmine/postunpack.sh
ENV APP_VERSION="5.0.2" \
    BITNAMI_APP_NAME="redmine" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:$PATH"

EXPOSE 3000

USER root
ENTRYPOINT [ "/opt/bitnami/scripts/redmine/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/redmine/run.sh" ]
