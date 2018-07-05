FROM bitnami/oraclelinux-extras:7-r26
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl git glibc keyutils-libs krb5-libs libcom_err libselinux ncurses-libs nss-softokn-freebl openssl-libs pcre pkg-config readline unzip wget zlib
RUN bitnami-pkg install ruby-2.4.4-0 --checksum 8623ed8b7963916ff7f5ecf56c62ce3c144a1d11e56767500d0034c8e4f7e17c
RUN /opt/bitnami/ruby/bin/gem install bundler

COPY rootfs /
ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.4.4-ol-7-r13" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

EXPOSE 3000

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["irb"]
