FROM bitnami/oraclelinux-extras:7-r429
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libcurl libidn libselinux libssh2 nspr nss nss-softokn-freebl nss-util openldap openssh-clients openssl-libs pcre zlib
RUN bitnami-pkg install git-2.22.1-0 --checksum 78b31b9af73a669b3bf0a27a890f9a9bd8acaf0b94ff4bca7e065b54a9c45e91

COPY rootfs /
ENV BITNAMI_APP_NAME="git" \
    BITNAMI_IMAGE_VERSION="2.22.1-ol-7-r3" \
    PATH="/opt/bitnami/git/bin:$PATH"

ENTRYPOINT [ "git" ]
CMD [ "--help" ]
