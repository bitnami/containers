FROM bitnami/minideb-extras:jessie-r87
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbsd0 libbz2-1.0 libc6 libedit2 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libhogweed2 libldap-2.4-2 liblzma5 libmysqlclient18 libncurses5 libnettle4 libp11-kit0 libpq5 libreadline6 libsasl2-2 libsqlite3-0 libssl1.0.0 libstdc++6 libtasn1-6 libtinfo5 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg install python-3.6.5-0 --checksum 6dcdb118903956ea59642f3799e65cd087c34218e316796c60adab0c76bdf102
RUN bitnami-pkg install postgresql-client-10.4.0-0 --checksum 9865f6ec8bb48878b9909e66e3addcaea83cd5e4f7908b62b43d5a058cbb5cd0
RUN bitnami-pkg install node-7.10.1-1 --checksum 7f326edcdc911932655af0283eb29e1f72d28f1e4f9a7cf5869618fff135cbdb
RUN bitnami-pkg unpack odoo-11.0.20180615-0 --checksum a1a48047026344791519de462d43cb62c7e96c6dd519f9e949457dd90722e2f9

COPY rootfs /
ENV BITNAMI_APP_NAME="odoo" \
    BITNAMI_IMAGE_VERSION="11.0.20180615-r0" \
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
