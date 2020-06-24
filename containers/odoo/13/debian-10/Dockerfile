FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/python/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/node/bin:/opt/bitnami/common/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl fontconfig ghostscript gzip imagemagick libbsd0 libbz2-1.0 libc6 libcap2-bin libedit2 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libhogweed4 libicu63 libidn2-0 libjpeg62-turbo libldap-2.4-2 liblzma5 libncursesw6 libnettle6 libp11-kit0 libpng16-16 libpq5 libreadline7 libsasl2-2 libsqlite3-0 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libx11-6 libxcb1 libxext6 libxml2 libxrender1 libxslt1.1 procps sudo tar xfonts-75dpi xfonts-base zlib1g
RUN /build/bitnami-user.sh
RUN /build/install-nami.sh
RUN bitnami-pkg install python-3.6.10-13 --checksum 06e7d2fd58444182b4008745ee50ff404f7dd715d681604ade35f07aef9048fc
RUN bitnami-pkg install postgresql-client-11.8.0-1 --checksum 732f07d8a39665702c3b69883e5c6e7c601a033dbac4a896843d8cf63026bc7f
RUN bitnami-pkg install node-12.18.1-0 --checksum f0ea0986d229d2b31f7f39e13955ee9a92c10ad1620dede0c1a4e55f3fa55493
RUN bitnami-pkg install tini-0.19.0-0 --checksum 9a8ae20be31a518f042fcec359f2cf35bfdb4e2a56f2fa8ff9ef2ecaf45da80c
RUN bitnami-pkg unpack odoo-13.0.20200610-0 --checksum 2223079265e9aaff6227b6d80e9272107cc83274cd37de3fe9696971504a98c5
RUN bitnami-pkg install gosu-1.12.0-0 --checksum 582d501eeb6b338a24f417fededbf14295903d6be55c52d66c52e616c81bcd8c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN curl -sLO https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.buster_amd64.deb && \
    echo "dfab5506104447eef2530d1adb9840ee3a67f30caaad5e9bcb8743ef2f9421bd  wkhtmltox_0.12.5-1.buster_amd64.deb" | sha256sum -c - && \
    dpkg -i wkhtmltox_0.12.5-1.buster_amd64.deb && \
    rm wkhtmltox_0.12.5-1.buster_amd64.deb

COPY rootfs /
ENV BITNAMI_APP_NAME="odoo" \
    BITNAMI_IMAGE_VERSION="13.0.20200610-debian-10-r12" \
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
    SMTP_USER=""

EXPOSE 3000 8069 8071

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "odoo" ]
