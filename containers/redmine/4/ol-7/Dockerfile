FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ImageMagick ca-certificates curl cyrus-sasl-lib ghostscript glibc gzip hostname keyutils-libs krb5-libs libaio-devel libcom_err libcurl libedit libgcc libidn libselinux libssh2 libstdc++ libuuid libxml2 libxslt mariadb-libs ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre postgresql-libs procps-ng readline sudo tar which xz-libs zlib
RUN /build/bitnami-user.sh && \
    /build/install-nami.sh
RUN bitnami-pkg install ruby-2.6.5-0 --checksum 29ef6f1ed911c95ada9710d617438ec90e6e822cae31d2b82d578f9b9e7b1c30
RUN bitnami-pkg install postgresql-client-11.6.0-0 --checksum c0df49723944b7b842053d0cfb4f2ffe0313575ecfbb213e113b50989d008c1a
RUN bitnami-pkg install mysql-client-10.3.22-0 --checksum a79d0068a2219cfa03e249f6eb38945b4f0c5a4d116771bcbe971470b0c29417
RUN bitnami-pkg install git-2.25.0-0 --checksum 2fd25c5b37cec238a759c3c3643c156d4fe5b00716e2152c7c494cf6729673c9
RUN bitnami-pkg unpack redmine-4.1.0-0 --checksum 4bcee5d2f53ad8dc6a93a1f6bd0ce6e9c5db16231d172806a6a5c53dad4ec785
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh
RUN /build/install-tini.sh

COPY rootfs /
ENV BITNAMI_APP_NAME="redmine" \
    BITNAMI_IMAGE_VERSION="4.1.0-ol-7-r44" \
    REDMINE_DB_MYSQL="mariadb" \
    REDMINE_DB_NAME="bitnami_redmine" \
    REDMINE_DB_PASSWORD="" \
    REDMINE_DB_PORT_NUMBER="" \
    REDMINE_DB_POSTGRES="" \
    REDMINE_DB_USERNAME="bn_redmine" \
    REDMINE_EMAIL="user@example.com" \
    REDMINE_LANGUAGE="en" \
    REDMINE_PASSWORD="bitnami1" \
    REDMINE_USERNAME="user" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_TLS="true" \
    SMTP_USER=""

EXPOSE 3000

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
