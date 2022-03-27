FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl fontconfig gzip libbsd0 libbz2-1.0 libc6 libcap2-bin libcom-err2 libedit2 libffi6 libfreetype6 libgcc1 libgmp10 libgnutls30 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncursesw6 libnettle6 libp11-kit0 libpng16-16 libpq5 libreadline7 libsasl2-2 libsqlite3-0 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libx11-6 libxcb1 libxext6 libxml2 libxrender1 libxslt1.1 procps tar xfonts-75dpi xfonts-base zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.13-2" --checksum 704fe6b545280ae027303b4ec875b495ee6da2256b3d8f877467077b0f031a60
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-10" --checksum 97c2ae4b001c5937e888b920bee7b1a40a076680caac53ded6d10f6207d54565
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "13.6.0-4" --checksum 10c4c8870775aa837cc37c243b20cde2efd166482aab0df90974c105884ea210
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.19.1-0" --checksum 806082b15c0eb60e4baca497519b4c0cc9cd636d7a944e9943ebc1b9632fabdc
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "odoo" "14.0.20220310-0" --checksum 25f79c7492fabe168e34d0b7f6f4f325fce9c99f371a1995853ad3265257faa6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN curl -sLO https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.buster_amd64.deb && \
    echo "dfab5506104447eef2530d1adb9840ee3a67f30caaad5e9bcb8743ef2f9421bd  wkhtmltox_0.12.5-1.buster_amd64.deb" | sha256sum -c - && \
    dpkg -i wkhtmltox_0.12.5-1.buster_amd64.deb && \
    rm wkhtmltox_0.12.5-1.buster_amd64.deb

COPY rootfs /
RUN /opt/bitnami/scripts/odoo/postunpack.sh
ENV APP_VERSION="14.0.20220310" \
    BITNAMI_APP_NAME="odoo" \
    BITNAMI_IMAGE_VERSION="14.0.20220310-debian-10-r16" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/node/bin:/opt/bitnami/odoo/bin:$PATH"

EXPOSE 3000 8069 8072

USER root
ENTRYPOINT [ "/opt/bitnami/scripts/odoo/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/odoo/run.sh" ]
