FROM bitnami/minideb-extras:jessie-r16
LABEL maintainer "Bitnami <containers@bitnami.com>"



# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbsd0 libbz2-1.0 libc6 libcomerr2 libedit2 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmysqlclient18 libncurses5 libnettle4 libp11-kit0 libpq5 libreadline6 libsasl2-2 libsqlite3-0 libssl1.0.0 libstdc++6 libtasn1-6 libtinfo5 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg install python-2.7.13-0 --checksum 7f5aac196054c7eb04c981243b4ddf37020cc3eb8a7cdc69d72da57212b21573
RUN bitnami-pkg install postgresql-client-9.6.3-0 --checksum fec96be76c0ba5f66a56fbc002b45092abc0100a6d9409d26ddc7391610236de
RUN bitnami-pkg install node-6.10.3-0 --checksum 07bb05274dd2cf71ebdd92ff00925bf1ff16588664e24f59a3b5ecfce7dce238
RUN bitnami-pkg unpack odoo-10.0.20170515-0 --checksum 65181474537dcf1ef4c1cec6214aa4f94fe3bb140d4c06bad2e5c87edb45792c

COPY rootfs /

ENV BITNAMI_APP_NAME="odoo" \
    BITNAMI_IMAGE_VERSION="10.0.20170515-r2" \
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



VOLUME ["/bitnami/odoo"]

EXPOSE 8069 8071

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","odoo"]
