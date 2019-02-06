FROM bitnami/oraclelinux-extras:7-r252
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libffi libgcc libgcrypt libgpg-error libselinux libstdc++ libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre readline sqlite xz-libs zlib
RUN bitnami-pkg install python-3.6.8-0 --checksum 4833c8498b63c2391e9d9ef6f0e8230b72bc3ce3d7f3cbfe1d3a0f387a5f7a89
RUN bitnami-pkg install postgresql-client-10.6.0-20 --checksum 3f1d493904e0c681e17c9135c92d2e51fea7b0161aa4c3c1ca64acf084e58eb1
RUN bitnami-pkg install node-7.10.1-1 --checksum c58b53a2ea5feafe1e0f0ef4b990d9ff55c37089ff5fba12e1938183e8a81a2f
RUN bitnami-pkg unpack odoo-11.0.20190115-0 --checksum 3661bcd47989f362ccb18ca43eabe154a4270eb71f095e7f781ff5db9c9d21a1

COPY rootfs /
ENV BITNAMI_APP_NAME="odoo" \
    BITNAMI_IMAGE_VERSION="11.0.20190115-ol-7-r17" \
    ODOO_EMAIL="user@example.com" \
    ODOO_PASSWORD="bitnami" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/node/bin:$PATH" \
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
