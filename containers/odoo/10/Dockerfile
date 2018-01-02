FROM bitnami/minideb-extras:jessie-r22
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbsd0 libbz2-1.0 libc6 libedit2 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libhogweed2 libldap-2.4-2 liblzma5 libmysqlclient18 libncurses5 libnettle4 libp11-kit0 libpq5 libreadline6 libsasl2-2 libsqlite3-0 libssl1.0.0 libstdc++6 libtasn1-6 libtinfo5 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg install python-2.7.14-0 --checksum 2ad513d9d4d4e2c2f98d96448617b5ab3c5dd48dc2e3cb02080ecc7215039ffa
RUN bitnami-pkg install postgresql-client-9.6.5-0 --checksum 96fe70bda6f0a296dcb594cd28b6810a03c6b4ba82c1ae13a228bda20cb4c423
RUN bitnami-pkg install node-6.12.2-0 --checksum f651b273eafa87721594448a51bd138aa6f8ec02059715d020a1a7fff873536c
RUN bitnami-pkg unpack odoo-10.0.20180102-0 --checksum 796f2ff1f4b810b0c5e133d1c54f16c9c8f5abf061140fe4b73a931f6c750e22

COPY rootfs /

ENV BITNAMI_APP_NAME="odoo" \
    BITNAMI_IMAGE_VERSION="10.0.20180102-r0" \
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
