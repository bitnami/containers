FROM bitnami/oraclelinux-extras:7-r582
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libcurl libidn libselinux libssh2 nspr nss nss-softokn-freebl nss-util openldap openssh-clients openssl-libs pcre zlib
RUN bitnami-pkg install git-2.24.1-0 --checksum ecc3a4f7b7a77ffb00ef66a9b02613c52a5b6d77bf9a5279fa139a66e6265460

COPY rootfs /
ENV BITNAMI_APP_NAME="git" \
    BITNAMI_IMAGE_VERSION="2.24.1-ol-7-r23" \
    PATH="/opt/bitnami/git/bin:$PATH"

ENTRYPOINT [ "git" ]
CMD [ "--help" ]
