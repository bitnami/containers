FROM bitnami/oraclelinux-extras:7-r468
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libcurl libidn libselinux libssh2 nspr nss nss-softokn-freebl nss-util openldap openssh-clients openssl-libs pcre zlib
RUN bitnami-pkg install git-2.23.0-0 --checksum 30618c63e72727b90b3cc3e7f8747e599ec11352b29812285a27029807d8766d

COPY rootfs /
ENV BITNAMI_APP_NAME="git" \
    BITNAMI_IMAGE_VERSION="2.23.0-ol-7-r34" \
    PATH="/opt/bitnami/git/bin:$PATH"

ENTRYPOINT [ "git" ]
CMD [ "--help" ]
