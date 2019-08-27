FROM bitnami/node:12.9.1-ol-7-r1 as development

######

FROM bitnami/oraclelinux-runtimes:7-r412
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates glibc keyutils-libs krb5-libs libcom_err libgcc libselinux libstdc++ ncurses-libs nss-softokn-freebl openssl-libs pcre readline sqlite wget zlib

COPY --from=development /opt/bitnami/node /opt/bitnami/node

ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="12.9.1-ol-7-r0-prod" \
    PATH="/opt/bitnami/node/bin:$PATH"

CMD [ "node" ]
