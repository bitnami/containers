FROM bitnami/minideb-extras:stretch-r493
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbsd0 libbz2-1.0 libc6 libedit2 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libhogweed4 libicu57 libidn11 libldap-2.4-2 liblzma5 libncurses5 libnettle6 libp11-kit0 libpq5 libreadline7 libsasl2-2 libsqlite3-0 libssl1.1 libstdc++6 libtasn1-6 libtinfo5 libuuid1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg install python-3.6.9-2 --checksum 7ed6019242d0e6928c6cb314e554d929970f6bbaa0b4c6c2f8631d4cf5f31f3b
RUN bitnami-pkg install postgresql-client-11.5.0-1 --checksum be6c93f500df6d1bbffe76a777ba862ed76dc5286a9443d271a950f6e557e869
RUN bitnami-pkg install node-7.10.1-1 --checksum 53362288e961d298a724353710a31901d4cb8237894a26a2f676b35450c02975
RUN bitnami-pkg unpack odoo-13.0.20191010-0 --checksum 10ad67ddf0a5a861280135afddbb228aa7253f31f512b751325a6308ed3c215a

COPY rootfs /
ENV BITNAMI_APP_NAME="odoo" \
    BITNAMI_IMAGE_VERSION="13.0.20191010-debian-9-r9" \
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
