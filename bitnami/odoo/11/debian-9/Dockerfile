FROM bitnami/minideb-extras:stretch-r173
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbsd0 libbz2-1.0 libc6 libedit2 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libhogweed4 libicu57 libidn11 libldap-2.4-2 liblzma5 libncurses5 libnettle6 libp11-kit0 libreadline7 libsasl2-2 libsqlite3-0 libssl1.1 libstdc++6 libtasn1-6 libtinfo5 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg install python-3.6.6-1 --checksum 0907288515dabfabb4fbdc326295d30311fccf881f9ecbb3da5243590af9a3a5
RUN bitnami-pkg install postgresql-client-10.5.0-1 --checksum 398cca9d24dd92dec294fd5727fa0a4841847a88d1316a11a338fd7d208ccb8f
RUN bitnami-pkg install node-7.10.1-1 --checksum 53362288e961d298a724353710a31901d4cb8237894a26a2f676b35450c02975
RUN bitnami-pkg unpack odoo-11.0.20181015-1 --checksum 44c7651f63d6c13231876522b4c9819e195fa813a0ab00579e41860344508e6e

COPY rootfs /
ENV BITNAMI_APP_NAME="odoo" \
    BITNAMI_IMAGE_VERSION="11.0.20181015-debian-9-r5" \
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
