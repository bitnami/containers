FROM bitnami/ruby:2.4.9-ol-7-r128 as development

######

FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl glibc gzip hostname keyutils-libs krb5-libs libaio-devel libcom_err libselinux ncurses-libs nss-softokn-freebl openssl-libs pcre procps-ng readline sudo tar which zlib
RUN yum upgrade -y && \
    rm -r /var/cache/yum

COPY --from=development /opt/bitnami/ruby /opt/bitnami/ruby

ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.4.9-ol-7-r122-prod" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

CMD [ "irb" ]
