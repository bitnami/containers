FROM bitnami/oraclelinux-extras:7-r338
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates cyrus-sasl-lib gcc-c++ glibc keyutils-libs krb5-libs libcom_err libcurl libgcc libidn libselinux libssh2 libstdc++ libxml2 make mysql-devel nc ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre pkgconfig readline zlib
RUN bitnami-pkg install ruby-2.6.3-0 --checksum edc7a2d314c592d73272df68e28490846c325d829cdcba97c41fe0fd19edc0f3
RUN bitnami-pkg install mysql-client-10.3.15-0 --checksum 8200bab1521dde4a6c377789abdff7f4b30d64843a4a78affb319f833f9f260f
RUN bitnami-pkg install git-2.21.0-0 --checksum 8dc7078aeaa3c3bf7010f3adbdb2f7ec9c3737c7eb6c7c1b2f547350c42fcfa5
RUN bitnami-pkg install rails-5.2.3-0-0 --checksum 57f3f739ebc3051ee3376f0d8087161a058d67bae8f88a248f457529e7e4ea72
RUN mkdir /app && chown bitnami:bitnami /app

COPY rootfs /
ENV BITNAMI_APP_NAME="rails" \
    BITNAMI_IMAGE_VERSION="5.2.3-0-ol-7-r38" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:/opt/bitnami/rails/bin:$PATH" \
    RAILS_ENV="development"

EXPOSE 3000

WORKDIR /app
USER bitnami
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000" ]
