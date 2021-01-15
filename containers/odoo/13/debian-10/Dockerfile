FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/python/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/node/bin:/opt/bitnami/common/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl fontconfig ghostscript gzip imagemagick libbsd0 libbz2-1.0 libc6 libcap2-bin libedit2 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libhogweed4 libicu63 libidn2-0 libjpeg62-turbo libldap-2.4-2 liblzma5 libncursesw6 libnettle6 libp11-kit0 libpng16-16 libpq5 libreadline7 libsasl2-2 libsqlite3-0 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libx11-6 libxcb1 libxext6 libxml2 libxrender1 libxslt1.1 procps sudo tar xfonts-75dpi xfonts-base zlib1g
RUN /build/bitnami-user.sh
RUN /build/install-nami.sh
RUN bitnami-pkg install python-3.6.12-10 --checksum cc3e62e05463929529214f65cb7922794c758a3db5ca29bf5c9a59fe66e95b80
RUN bitnami-pkg install postgresql-client-11.10.0-0 --checksum ad9f4e750583d0f7b02afc119c3b505fc780c0c13407983a96f2923dc7e33c3e
RUN bitnami-pkg install node-14.15.4-0 --checksum 1c23a75145fc202950f12bd6cb13a9c9b3ac35a3a09d194c105912d2f4d4a8a6
RUN bitnami-pkg install tini-0.19.0-1 --checksum 9b1f1c095944bac88a62c1b63f3bff1bb123aa7ccd371c908c0e5b41cec2528d
RUN bitnami-pkg unpack odoo-13.0.20210110-0 --checksum b0b043d26ad9665ea73a1267b5e4fd758b36ff84fcd06c71b5cbd3e32396da66
RUN bitnami-pkg install gosu-1.12.0-2 --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN curl -sLO https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.buster_amd64.deb && \
    echo "dfab5506104447eef2530d1adb9840ee3a67f30caaad5e9bcb8743ef2f9421bd  wkhtmltox_0.12.5-1.buster_amd64.deb" | sha256sum -c - && \
    dpkg -i wkhtmltox_0.12.5-1.buster_amd64.deb && \
    rm wkhtmltox_0.12.5-1.buster_amd64.deb

COPY rootfs /
ENV BITNAMI_APP_NAME="odoo" \
    BITNAMI_IMAGE_VERSION="13.0.20210110-debian-10-r5" \
    LD_LIBRARY_PATH="/opt/bitnami/odoo/venv/lib/python3.6/site-packages/reportlab/.libs:$LD_LIBRARY_PATH" \
    ODOO_EMAIL="user@example.com" \
    ODOO_PASSWORD="bitnami" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    POSTGRESQL_HOST="postgresql" \
    POSTGRESQL_PASSWORD="" \
    POSTGRESQL_PORT_NUMBER="5432" \
    POSTGRESQL_USER="postgres" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER="" \
    WITHOUT_DEMO="all"

EXPOSE 3000 8069 8071

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "odoo" ]
