FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl fontconfig gzip libbsd0 libbz2-1.0 libc6 libcap2-bin libcom-err2 libedit2 libffi6 libfreetype6 libgcc1 libgmp10 libgnutls30 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncursesw6 libnettle6 libp11-kit0 libpng16-16 libpq5 libreadline7 libsasl2-2 libsqlite3-0 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libx11-6 libxcb1 libxext6 libxml2 libxrender1 libxslt1.1 procps tar xfonts-75dpi xfonts-base zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.12-11" --checksum 18529e5433b2ff7007527ec2fa5b608cb6432e27ec3e6a9f3ab94fcdb7586475
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-4" --checksum 9b09b8c13e726569fd846abef20228b2e29de456805994e512f3b47f74cf742d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "13.5.0-0" --checksum eb9051af5a9077ff41349b271ffd1029af7088bcf3d1f5ac81c2c6707801fbec
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.18.2-0" --checksum 5753bbbe5052000888c24ef8c918cfc45577878b03cc4dcfe7d53ea562a48e5a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "odoo" "15.0.20211210-0" --checksum ba1329ca5f8addfa9c9e11775221450b71dc7d1547d0fd7de2688d4f71c70f5b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN chmod g+rwX /opt/bitnami
RUN curl -sLO https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.buster_amd64.deb && \
    echo "dfab5506104447eef2530d1adb9840ee3a67f30caaad5e9bcb8743ef2f9421bd  wkhtmltox_0.12.5-1.buster_amd64.deb" | sha256sum -c - && \
    dpkg -i wkhtmltox_0.12.5-1.buster_amd64.deb && \
    rm wkhtmltox_0.12.5-1.buster_amd64.deb

COPY rootfs /
RUN /opt/bitnami/scripts/odoo/postunpack.sh
ENV BITNAMI_APP_NAME="odoo" \
    BITNAMI_IMAGE_VERSION="15.0.20211210-debian-10-r22" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/node/bin:/opt/bitnami/odoo/bin:$PATH" \
    POSTGRESQL_CLIENT_CREATE_DATABASE_NAME="" \
    POSTGRESQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    POSTGRESQL_CLIENT_CREATE_DATABASE_USERNAME="" \
    POSTGRESQL_HOST="postgresql" \
    POSTGRESQL_PORT_NUMBER="5432" \
    POSTGRESQL_ROOT_PASSWORD="" \
    POSTGRESQL_ROOT_USER="postgres"

EXPOSE 3000 8069 8072

USER root
ENTRYPOINT [ "/opt/bitnami/scripts/odoo/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/odoo/run.sh" ]
