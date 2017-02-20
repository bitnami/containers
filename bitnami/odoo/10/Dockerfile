FROM gcr.io/stacksmith-images/minideb:jessie-r9

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=odoo \
    BITNAMI_IMAGE_VERSION=10.0.20170215-r0 \
    PATH=/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/postgresql/bin:$PATH

# System packages required
RUN install_packages libc6 libssl1.0.0 libncurses5 libtinfo5 zlib1g libsqlite3-0 libreadline6 libxslt1.1 libxml2 liblzma5 libedit2 libbsd0 libbz2-1.0 libstdc++6 libgcc1 ghostscript imagemagick libmysqlclient18 libpq5 libgssapi-krb5-2 libldap-2.4-2 libkrb5-3 libk5crypto3 libcomerr2 libkrb5support0 libkeyutils1 libsasl2-2 libgnutls-deb0-28 libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libgmp10 libffi6 libgcrypt20 libgpg-error0

# Additional modules required
RUN bitnami-pkg install python-2.7.13-0 --checksum 7f5aac196054c7eb04c981243b4ddf37020cc3eb8a7cdc69d72da57212b21573
RUN bitnami-pkg install postgresql-client-9.6.2-1 --checksum 363d32e555bb33e1e13c744d6921a91d933d7e54a5c990b2e66f4e12ec91e442
RUN bitnami-pkg install node-6.9.5-0 --checksum a0ea55e9a34d38099a310500f708ebb3712f7fae41a83deaffb9c4b655684531

# Install odoo
RUN bitnami-pkg unpack odoo-10.0.20170215-0 --checksum 5385e2c23f1f9f97170cc736c9f6842bab8ebf0b7cb7a59c1300af7999f59310

COPY rootfs /

ENV ODOO_PASSWORD="bitnami" \
    ODOO_EMAIL="user@example.com" \
    POSTGRESQL_USER="postgres" \
    POSTGRESQL_HOST="postgresql" \
    POSTGRESQL_PORT="5432"

VOLUME ["/bitnami/odoo"]

EXPOSE 8069 8071

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "odoo"]
