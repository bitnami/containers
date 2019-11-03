FROM bitnami/oraclelinux-extras-base:7-r468
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc keyutils-libs krb5-libs libcom_err libgcc libselinux libyaml nss-softokn-freebl openssl-libs pcre perl zlib
RUN . ./libcomponent.sh && component_unpack "kong" "1.4.0-0" --checksum 0336b221a952a394e401a116d33e3877110d332a329c48039bef56630800106c

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="kong" \
    BITNAMI_IMAGE_VERSION="1.4.0-ol-7-r11" \
    PATH="/opt/bitnami/kong/bin:/opt/bitnami/kong/openresty/bin:/opt/bitnami/kong/openresty/luajit/bin:/opt/bitnami/kong/openresty/nginx/sbin:$PATH"

EXPOSE 8000 8001 8443 8444

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
