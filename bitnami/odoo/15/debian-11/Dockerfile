FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="15.0.20220810-debian-11-r6" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/odoo" \
      org.opencontainers.image.title="odoo" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="15.0.20220810"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl fontconfig gzip libbrotli1 libbsd0 libbz2-1.0 libc6 libcap2-bin libcom-err2 libcrypt1 libedit2 libffi7 libfreetype6 libgcc-s1 libgmp10 libgnutls30 libgssapi-krb5-2 libhogweed6 libicu67 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmd0 libncursesw6 libnettle8 libnsl2 libp11-kit0 libpng16-16 libpq5 libreadline8 libsasl2-2 libsqlite3-0 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libtirpc3 libunistring2 libuuid1 libx11-6 libxcb1 libxext6 libxml2 libxrender1 libxslt1.1 procps tar xfonts-75dpi xfonts-base zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.10.6-7" --checksum 02e5a66908664141ad80a1d40b390a71e8cec13771cb38600c322d36747fb298
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.3-153" --checksum c1f2cdabdcc920512e8936ab2c8a033e1aeb97801fa026f0b12432581bf849ae
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "13.8.0-1" --checksum ed27577fe07511a7ff3ba58800604c463387cdd21fb3f64473e75f327b73565d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.20.0-3" --checksum 49946e0443d8f479f296c79589fea205126b6f6faa6b4474e5dd713b36d8167c
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "odoo" "15.0.20220810-1" --checksum e31245a99e155cb28db015958240d05d647d23e3527afa0762a53f425c4ff4a3
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-154" --checksum e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN if [ "$OS_ARCH" = "amd64" ]; then \
    curl -sLO "https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.buster_${OS_ARCH}.deb" && \
    echo "dfab5506104447eef2530d1adb9840ee3a67f30caaad5e9bcb8743ef2f9421bd  wkhtmltox_0.12.5-1.buster_${OS_ARCH}.deb" | sha256sum -c - && \
    dpkg -i "wkhtmltox_0.12.5-1.buster_${OS_ARCH}.deb" && \
    rm wkhtmltox_0.12.5-1.buster_${OS_ARCH}.deb \
    ; fi

COPY rootfs /
RUN /opt/bitnami/scripts/odoo/postunpack.sh
ENV APP_VERSION="15.0.20220810" \
    BITNAMI_APP_NAME="odoo" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/node/bin:/opt/bitnami/odoo/bin:$PATH"

EXPOSE 3000 8069 8072

USER root
ENTRYPOINT [ "/opt/bitnami/scripts/odoo/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/odoo/run.sh" ]
