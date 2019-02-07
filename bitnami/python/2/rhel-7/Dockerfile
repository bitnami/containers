FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages build-essential curl git glibc keyutils-libs krb5-libs libcom_err libselinux ncurses-libs nss-softokn-freebl openssl-libs pcre pkg-config unzip zlib
RUN bitnami-pkg install python-2.7.15-20 --checksum 026d98bfeddf908ba9774e2a54b992ece8877f5e07ed1e991f44747c2b22c59c

COPY rootfs /
ENV BITNAMI_APP_NAME="python" \
    BITNAMI_IMAGE_VERSION="2.7.15-rhel-7-r15" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/python/bin:$PATH"

EXPOSE 8000

WORKDIR /app
USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "python" ]
