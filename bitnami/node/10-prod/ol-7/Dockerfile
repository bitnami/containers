FROM bitnami/node:10.18.1-ol-7-r21 as development

######

FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates curl glibc gzip hostname keyutils-libs krb5-libs libaio-devel libcom_err libgcc libselinux libstdc++ ncurses-libs nss-softokn-freebl openssl-libs pcre procps-ng readline sqlite sudo tar which zlib
RUN yum upgrade -y && \
    rm -r /var/cache/yum

COPY --from=development /opt/bitnami/node /opt/bitnami/node

ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="10.18.1-ol-7-r20-prod" \
    PATH="/opt/bitnami/node/bin:$PATH"

CMD [ "node" ]
