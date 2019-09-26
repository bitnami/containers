FROM bitnami/oraclelinux-extras:7-r478
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libcurl libidn libselinux libssh2 nspr nss nss-softokn-freebl nss-util openldap openssh-clients openssl-libs pcre zlib
RUN bitnami-pkg install git-2.23.0-1 --checksum a145f72a986e09dbdb13ce0d1ccbaf2bb78c8571610f4d3d61b8d97abab0c342

COPY rootfs /
ENV BITNAMI_APP_NAME="git" \
    BITNAMI_IMAGE_VERSION="2.23.0-ol-7-r45" \
    PATH="/opt/bitnami/git/bin:$PATH"

ENTRYPOINT [ "git" ]
CMD [ "--help" ]
