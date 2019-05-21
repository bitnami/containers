FROM bitnami/oraclelinux-extras:7-r343
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libedit libffi libgcc libgcrypt libgpg-error libselinux libstdc++ libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre readline sqlite xz-libs zlib
RUN bitnami-pkg install python-3.6.8-2 --checksum ef147d69b97d735e099fe281f6e7270ad9d5101eb2a4aca364525b1776b2e6ae
RUN bitnami-pkg install postgresql-client-11.3.0-0 --checksum 85cdf4e7ac8df71922a0ed95cd8c61f7b630070b3a315e46844a6b49a25c15d4
RUN bitnami-pkg install node-7.10.1-1 --checksum c58b53a2ea5feafe1e0f0ef4b990d9ff55c37089ff5fba12e1938183e8a81a2f
RUN bitnami-pkg unpack odoo-12.0.20190515-0 --checksum 4991fb29dd968556d43fd3f20838a1992a45f6f21b1f8a66448a7fd42e27c2ba

COPY rootfs /
ENV BITNAMI_APP_NAME="odoo" \
    BITNAMI_IMAGE_VERSION="12.0.20190515-ol-7-r0" \
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
