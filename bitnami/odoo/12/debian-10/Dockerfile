FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/python/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/node/bin:/opt/bitnami/common/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates ca-certificates  curl dirmngr fontconfig  ghostscript gnupg imagemagick libbsd0 libbz2-1.0 libc6 libc6  libedit2 libffi6 libfreetype6  libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libhogweed4 libicu63 libidn2-0 libjpeg62-turbo  libldap-2.4-2 liblzma5 libncursesw6 libnettle6 libp11-kit0 libpng16-16  libpq5 libreadline7 libsasl2-2 libsqlite3-0 libssl1.1 libssl1.1  libstdc++6 libstdc++6  libtasn1-6 libtinfo6 libunistring2 libuuid1 libx11-6  libxcb1  libxext6  libxml2 libxrender1  libxslt1.1 procps sudo unzip xfonts-75dpi  xfonts-base  zlib1g
RUN /build/bitnami-user.sh
RUN /build/install-nami.sh
RUN bitnami-pkg install python-3.6.10-3 --checksum 9211a0faa0fd4a39ddec622d28d5390b89b3eaef162c3822a3dfb636c14bf7b7
RUN bitnami-pkg install postgresql-client-11.7.0-2 --checksum d6dc43bc9f9686745817c372dce19728c88fa67237baf0be3c6dc1737c653f9c
RUN bitnami-pkg install node-12.16.3-0 --checksum 88affa3a429facdb603733ef9182b682c6be1b73707ebbabf8c73917da7e47f9
RUN bitnami-pkg install tini-0.19.0-0 --checksum 9a8ae20be31a518f042fcec359f2cf35bfdb4e2a56f2fa8ff9ef2ecaf45da80c
RUN bitnami-pkg unpack odoo-12.0.20200415-0 --checksum 45bef2792185edb8da8926ae41f9162ccba70be9d2c9ec934947354cc2809470
RUN bitnami-pkg install gosu-1.12.0-0 --checksum 582d501eeb6b338a24f417fededbf14295903d6be55c52d66c52e616c81bcd8c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN curl -sLO https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.buster_amd64.deb && \
    echo "dfab5506104447eef2530d1adb9840ee3a67f30caaad5e9bcb8743ef2f9421bd  wkhtmltox_0.12.5-1.buster_amd64.deb" | sha256sum -c - && \
    dpkg -i wkhtmltox_0.12.5-1.buster_amd64.deb && \
    rm wkhtmltox_0.12.5-1.buster_amd64.deb

COPY rootfs /
ENV BITNAMI_APP_NAME="odoo" \
    BITNAMI_IMAGE_VERSION="12.0.20200415-debian-10-r23" \
    LD_LIBRARY_PATH="/opt/bitnami/odoo/venv/lib/python3.6/site-packages/reportlab/.libs:$LD_LIBRARY_PATH" \
    ODOO_EMAIL="user@example.com" \
    ODOO_PASSWORD="bitnami" \
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
