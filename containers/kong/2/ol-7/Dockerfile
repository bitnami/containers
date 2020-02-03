FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl glibc gzip hostname keyutils-libs krb5-libs libaio-devel libcom_err libgcc libselinux libyaml nss-softokn-freebl openssl-libs pcre perl procps-ng sudo tar which zlib
RUN . ./libcomponent.sh && component_unpack "kong" "2.0.0-0" --checksum 1a3ed93155b3fa4175804d2aa39461a762fc0f4a13957b5e198c9329f42c94e8
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="kong" \
    BITNAMI_IMAGE_VERSION="2.0.0-ol-7-r0" \
    PATH="/opt/bitnami/kong/bin:/opt/bitnami/kong/openresty/bin:/opt/bitnami/kong/openresty/luajit/bin:/opt/bitnami/kong/openresty/nginx/sbin:$PATH"

EXPOSE 8000 8001 8443 8444

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
