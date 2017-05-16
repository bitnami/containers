FROM bitnami/minideb-extras:jessie-r15

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=odoo \
    BITNAMI_IMAGE_VERSION=10.0.20170515-r0 \
    PATH=/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/postgresql/bin:$PATH

# System packages required
RUN install_packages libc6 libssl1.0.0 libncurses5 libtinfo5 zlib1g libsqlite3-0 libreadline6 libxslt1.1 libxml2 liblzma5 libedit2 libbsd0 libbz2-1.0 libstdc++6 libgcc1 ghostscript imagemagick libmysqlclient18 libldap-2.4-2 libsasl2-2 libgnutls-deb0-28 libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libgmp10 libffi6 libgcrypt20 libgpg-error0 libpq5 libgssapi-krb5-2 libkrb5-3 libk5crypto3 libcomerr2 libkrb5support0 libkeyutils1

# Additional modules required
RUN bitnami-pkg install python-2.7.13-0 --checksum 7f5aac196054c7eb04c981243b4ddf37020cc3eb8a7cdc69d72da57212b21573
RUN bitnami-pkg install postgresql-client-9.6.2-2 --checksum 1cb6a386042968d222f6f2dc6ba44ec973c4926e941aee14862e6cfed4bb9834
RUN bitnami-pkg install node-6.10.3-0 --checksum 07bb05274dd2cf71ebdd92ff00925bf1ff16588664e24f59a3b5ecfce7dce238

# Install odoo
RUN bitnami-pkg unpack odoo-10.0.20170515-0 --checksum 65181474537dcf1ef4c1cec6214aa4f94fe3bb140d4c06bad2e5c87edb45792c

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
