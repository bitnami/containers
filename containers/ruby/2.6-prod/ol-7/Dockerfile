FROM bitnami/ruby:2.6.5-ol-7-r100 as development

######

FROM bitnami/oraclelinux-runtimes:7-r557
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates glibc keyutils-libs krb5-libs libcom_err libselinux ncurses-libs nss-softokn-freebl openssl-libs pcre readline wget zlib

COPY --from=development /opt/bitnami/ruby /opt/bitnami/ruby

ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.6.5-ol-7-r101-prod" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

CMD [ "irb" ]
