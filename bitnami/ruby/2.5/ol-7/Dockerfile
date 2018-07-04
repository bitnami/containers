FROM bitnami/oraclelinux-extras:7-r25
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl git glibc keyutils-libs krb5-libs libcom_err libselinux ncurses-libs nss-softokn-freebl openssl-libs pcre pkg-config readline unzip wget zlib
RUN bitnami-pkg install ruby-2.5.1-0 --checksum ec0d6bd902785a38ac057bc6e9ff243c78d5973e5345adeadc81184d32453511
RUN /opt/bitnami/ruby/bin/gem install bundler

COPY rootfs /
ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.5.1-ol-7-r12" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

EXPOSE 3000

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["irb"]
