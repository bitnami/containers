FROM bitnami/oraclelinux-extras:7-r136
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libffi libgcc libgcrypt libgpg-error libselinux libstdc++ libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre readline sqlite xz-libs zlib
RUN bitnami-pkg install python-3.6.6-0 --checksum 1bf0fa90bf6782e3ff638b7b1b74b384b546ed0d89d81a558a7536d2f528a2d8
RUN bitnami-pkg install postgresql-client-10.5.0-0 --checksum f3a5894a09eec21e95caa4ef9f5e1c7dfe906e1ae1075ba70f0ef6d6e4e2585e
RUN bitnami-pkg install node-7.10.1-1 --checksum c58b53a2ea5feafe1e0f0ef4b990d9ff55c37089ff5fba12e1938183e8a81a2f
RUN bitnami-pkg unpack odoo-11.0.20180915-1 --checksum f010de9cabe23fd18a4339d8629b55a7b07e3ef06339a726147665ad31d3614c

COPY rootfs /
ENV BITNAMI_APP_NAME="odoo" \
    BITNAMI_IMAGE_VERSION="11.0.20180915-ol-7-r25" \
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
