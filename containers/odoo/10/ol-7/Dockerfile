FROM bitnami/oraclelinux-extras:7-r23
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libgcc libgcrypt libgpg-error libselinux libstdc++ libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre readline sqlite xz-libs zlib
RUN bitnami-pkg install python-2.7.15-1 --checksum b68b70cfe101ab13fc94c774c62915ed44207261b6a5ee091f0b504a1d73e945
RUN bitnami-pkg install postgresql-client-10.4.0-0 --checksum 1b5a69901fd8f8d9fd7434296c7c286ac39d5f875ff9815c157b3355c902fe34
RUN bitnami-pkg install node-7.10.1-1 --checksum c58b53a2ea5feafe1e0f0ef4b990d9ff55c37089ff5fba12e1938183e8a81a2f
RUN bitnami-pkg unpack odoo-10.0.20180615-0 --checksum 8201cd9359bc41e2f9571598fbe1f68fe77cc5578c59c6490ea2f235becc674a

COPY rootfs /
ENV BITNAMI_APP_NAME="odoo" \
    BITNAMI_IMAGE_VERSION="10.0.20180615-ol-7-r10" \
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

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","odoo"]
