FROM bitnami/python:3.7.6-ol-7-r19 as development

######

FROM bitnami/oraclelinux-runtimes:7-r557
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates glibc keyutils-libs krb5-libs libcom_err libffi libselinux ncurses-libs nss-softokn-freebl openssl-libs pcre readline sqlite wget xz-libs zlib

COPY --from=development /opt/bitnami/python /opt/bitnami/python

ENV BITNAMI_APP_NAME="python" \
    BITNAMI_IMAGE_VERSION="3.7.6-ol-7-r19-prod" \
    PATH="/opt/bitnami/python/bin:$PATH"

CMD [ "python" ]
