FROM bitnami/minideb-extras:stretch-r80
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbsd0 libbz2-1.0 libc6 libedit2 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libhogweed4 libicu57 libidn11 libldap-2.4-2 liblzma5 libncurses5 libnettle6 libp11-kit0 libpq5 libreadline7 libsasl2-2 libsqlite3-0 libssl1.1 libstdc++6 libtasn1-6 libtinfo5 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg install python-3.6.5-0 --checksum 9fd533b02418f733acf7b12d265a0bba7475827f6e2c8ea51621fa7c9bbabd56
RUN bitnami-pkg install postgresql-client-10.4.0-1 --checksum 1d8b6d049b4e04b428095c23bcd6d9fdda48fa69a34dd017a8b1def29bab6f6b
RUN bitnami-pkg install node-7.10.1-1 --checksum 53362288e961d298a724353710a31901d4cb8237894a26a2f676b35450c02975
RUN bitnami-pkg unpack odoo-11.0.20180615-2 --checksum b3c97f397989fa28033cbcb549dd113416817b51c96f3d484ca3de41f52c0b65

COPY rootfs /
ENV BITNAMI_APP_NAME="odoo" \
    BITNAMI_IMAGE_VERSION="11.0.20180615-debian-9-r10" \
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
