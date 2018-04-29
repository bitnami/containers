FROM bitnami/minideb-extras:jessie-r34
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbsd0 libbz2-1.0 libc6 libedit2 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libhogweed2 libldap-2.4-2 liblzma5 libmysqlclient18 libncurses5 libnettle4 libp11-kit0 libpq5 libreadline6 libsasl2-2 libsqlite3-0 libssl1.0.0 libstdc++6 libtasn1-6 libtinfo5 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg install python-3.6.5-0 --checksum 6dcdb118903956ea59642f3799e65cd087c34218e316796c60adab0c76bdf102
RUN bitnami-pkg install postgresql-client-10.3.0-0 --checksum b91bdcfa32a2e0c96995c51a42b725986126079525439984cfc43b4c32b733f8
RUN bitnami-pkg install node-7.10.1-1 --checksum 7f326edcdc911932655af0283eb29e1f72d28f1e4f9a7cf5869618fff135cbdb
RUN bitnami-pkg unpack odoo-11.0.20180415-0 --checksum 816c3663907d65177b977f6f8fae18278b035aed539dbc70ea2e7cd5d46eefa8

COPY rootfs /
ENV BITNAMI_APP_NAME="odoo" \
    BITNAMI_IMAGE_VERSION="11.0.20180415-r6" \
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
