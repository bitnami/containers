FROM bitnami/oraclelinux-extras:7-r24
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl git glibc keyutils-libs krb5-libs libcom_err libselinux ncurses-libs nss-softokn-freebl openssl-libs pcre pkg-config readline unzip wget zlib
RUN bitnami-pkg install ruby-2.3.7-0 --checksum 0ba6f774c89bc5d292c3e199a1ef91cb6dad55d0ef89fa6d952b8a276744d6f6
RUN /opt/bitnami/ruby/bin/gem install bundler

COPY rootfs /
ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.3.7-ol-7-r11" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

EXPOSE 3000

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["irb"]
