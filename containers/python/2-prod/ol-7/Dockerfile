FROM bitnami/python:2.7.15-ol-7-r210 as development

######

FROM bitnami/oraclelinux-runtimes:7-r231
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates glibc keyutils-libs krb5-libs libcom_err libselinux ncurses-libs nss-softokn-freebl openssl-libs pcre readline sqlite wget zlib

COPY --from=development /opt/bitnami/python /opt/bitnami/python

ENV BITNAMI_APP_NAME="python" \
    BITNAMI_IMAGE_VERSION="2.7.15-ol-7-r8-prod" \
    PATH="/opt/bitnami/python/bin:$PATH"

CMD [ "python" ]
