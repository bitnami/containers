FROM bitnami/oraclelinux-extras:7-r553
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libcurl libidn libselinux libssh2 nspr nss nss-softokn-freebl nss-util openldap openssh-clients openssl-libs pcre zlib
RUN bitnami-pkg install git-2.24.0-0 --checksum a05099de6d8c26088d81b69c3519e45e481d4605beffaa509eb5b6e6dfed0d90

COPY rootfs /
ENV BITNAMI_APP_NAME="git" \
    BITNAMI_IMAGE_VERSION="2.24.0-ol-7-r33" \
    PATH="/opt/bitnami/git/bin:$PATH"

ENTRYPOINT [ "git" ]
CMD [ "--help" ]
