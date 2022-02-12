FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl fontconfig gzip libbsd0 libbz2-1.0 libc6 libcap2-bin libcom-err2 libedit2 libffi6 libfreetype6 libgcc1 libgmp10 libgnutls30 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncursesw6 libnettle6 libp11-kit0 libpng16-16 libpq5 libreadline7 libsasl2-2 libsqlite3-0 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libx11-6 libxcb1 libxext6 libxml2 libxrender1 libxslt1.1 procps tar xfonts-75dpi xfonts-base zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.12-31" --checksum 48db897c12810ff5f17a323e9b4a0cc2812e673d66f94feb9d90e3abb28e664b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-7" --checksum ed811d10882450d4755b893d5e034a0dd912cdb4f261dd332ddf6363411cc0ba
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "13.6.0-1" --checksum 7677c5c3187f00595393dfcbab89de5626d08cafd9888c19a5ef74ce6c361630
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.19.0-1" --checksum 400fb188f20ebb22fe9a99f6ef46598902884b9fbd87da481455cbc60273497d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "odoo" "14.0.20220210-1" --checksum 7901415aa0c82033318609b9c2c32403d5ee8636e421375bfcb8088d6e7473bf
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-4" --checksum ec62006ece7e0b49c65926e458ba2b71d6d251552118b1378840b1803dbb3d53
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN curl -sLO https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.buster_amd64.deb && \
    echo "dfab5506104447eef2530d1adb9840ee3a67f30caaad5e9bcb8743ef2f9421bd  wkhtmltox_0.12.5-1.buster_amd64.deb" | sha256sum -c - && \
    dpkg -i wkhtmltox_0.12.5-1.buster_amd64.deb && \
    rm wkhtmltox_0.12.5-1.buster_amd64.deb

COPY rootfs /
RUN /opt/bitnami/scripts/odoo/postunpack.sh
ENV BITNAMI_APP_NAME="odoo" \
    BITNAMI_IMAGE_VERSION="14.0.20220210-debian-10-r2" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/node/bin:/opt/bitnami/odoo/bin:$PATH"

EXPOSE 3000 8069 8072

USER root
ENTRYPOINT [ "/opt/bitnami/scripts/odoo/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/odoo/run.sh" ]
