FROM bitnami/minideb-extras:jessie-r20
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbsd0 libbz2-1.0 libc6 libedit2 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libhogweed2 libldap-2.4-2 liblzma5 libmysqlclient18 libncurses5 libnettle4 libp11-kit0 libpq5 libreadline6 libsasl2-2 libsqlite3-0 libssl1.0.0 libstdc++6 libtasn1-6 libtinfo5 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg install python-2.7.13-0 --checksum 7f5aac196054c7eb04c981243b4ddf37020cc3eb8a7cdc69d72da57212b21573
RUN bitnami-pkg install postgresql-client-9.6.3-0 --checksum fec96be76c0ba5f66a56fbc002b45092abc0100a6d9409d26ddc7391610236de
RUN bitnami-pkg install node-6.11.2-0 --checksum dae29e64f394dc3e3b37434d3cba2518e2a00e876a6c94cf7396632c266e520b
RUN bitnami-pkg unpack odoo-10.0.20170802-0 --checksum b1fc796d4529a373e10924b0b740eb4d5036ce494f4487bdab39a61bb64b57af

COPY rootfs /

ENV BITNAMI_APP_NAME="odoo" \
    BITNAMI_IMAGE_VERSION="10.0.20170802-r0" \
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
