FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/python/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/node/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates curl cyrus-sasl-lib glibc gzip hostname keyutils-libs krb5-libs libaio-devel libcom_err libedit libffi libgcc libgcrypt libgpg-error libselinux libstdc++ libuuid libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre procps-ng readline sqlite sudo tar which xz-libs zlib
RUN /build/bitnami-user.sh && \
    /build/install-nami.sh
RUN bitnami-pkg install python-3.6.10-0 --checksum 5a8e49832c587612e6b4afa4dfe4708dc2153263ec594006eb7972c3352773b3
RUN bitnami-pkg install postgresql-client-11.7.0-0 --checksum 42b639dbc64ff5b40dc1dffc8ed1e9bed4320480706b2d76313ebeb3203b9f0c
RUN bitnami-pkg install node-12.16.0-0 --checksum 75e7e97a571c4dd9198f8b6b1eb76b6f3ce0799e099dd3dbaa6da7cbb317c607
RUN bitnami-pkg unpack odoo-12.0.20200215-0 --checksum 5edb7325f78cea1eff48ac7f4ec1c28f7978e46f4f32a15180323fca19eb321a
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh
RUN /build/install-tini.sh

COPY rootfs /
ENV BITNAMI_APP_NAME="odoo" \
    BITNAMI_IMAGE_VERSION="12.0.20200215-ol-7-r1" \
    LD_LIBRARY_PATH="/opt/bitnami/odoo/venv/lib/python3.6/site-packages/reportlab/.libs:$LD_LIBRARY_PATH" \
    ODOO_EMAIL="user@example.com" \
    ODOO_PASSWORD="bitnami" \
    POSTGRESQL_HOST="postgresql" \
    POSTGRESQL_PASSWORD="" \
    POSTGRESQL_PORT_NUMBER="5432" \
    POSTGRESQL_USER="postgres" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER=""

EXPOSE 8069 8071

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "odoo" ]
