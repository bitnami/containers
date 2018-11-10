FROM bitnami/oraclelinux-extras:7-r164
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libcurl libidn libselinux libssh2 nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre zlib
RUN bitnami-pkg install git-2.19.1-2 --checksum f216b1ac61b0bf86f3531671dee5be53c42ea436789484961bb41148911b32fa

COPY rootfs /
ENV BITNAMI_APP_NAME="git" \
    BITNAMI_IMAGE_VERSION="2.19.1-ol-7-r9" \
    PATH="/opt/bitnami/git/bin:$PATH"

ENTRYPOINT [ "git" ]
CMD [ "--help" ]
