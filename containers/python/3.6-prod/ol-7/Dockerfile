FROM bitnami/python:3.6.10-ol-7-r43 as development

######

FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates curl glibc gzip hostname keyutils-libs krb5-libs libaio-devel libcom_err libffi libselinux ncurses-libs nss-softokn-freebl openssl-libs pcre procps-ng readline sqlite sudo tar which xz-libs zlib
RUN yum upgrade -y && \
    rm -r /var/cache/yum

COPY --from=development /opt/bitnami/python /opt/bitnami/python

ENV BITNAMI_APP_NAME="python" \
    BITNAMI_IMAGE_VERSION="3.6.10-ol-7-r46-prod" \
    PATH="/opt/bitnami/python/bin:$PATH"

CMD [ "python" ]
