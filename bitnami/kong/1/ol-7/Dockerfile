FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl glibc gzip hostname keyutils-libs krb5-libs libaio-devel libcom_err libgcc libselinux libyaml nss-softokn-freebl openssl-libs pcre perl procps-ng sudo tar which zlib
RUN . ./libcomponent.sh && component_unpack "kong" "1.4.2-1" --checksum fe8c1905e777d2b3daebfe36a6b91584bebe40647dca389ed4f73ea2c2dd8328
RUN yum upgrade -y && \
    rm -r /var/cache/yum

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="kong" \
    BITNAMI_IMAGE_VERSION="1.4.2-ol-7-r19" \
    PATH="/opt/bitnami/kong/bin:/opt/bitnami/kong/openresty/bin:/opt/bitnami/kong/openresty/luajit/bin:/opt/bitnami/kong/openresty/nginx/sbin:$PATH"

EXPOSE 8000 8001 8443 8444

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
