FROM bitnami/oraclelinux-extras:7-r561
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates cyrus-sasl-lib gcc-c++ glibc keyutils-libs krb5-libs libcom_err libcurl libgcc libidn libselinux libssh2 libstdc++ libxml2 make mysql-devel nc ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre pkgconfig readline sqlite zlib
RUN bitnami-pkg install ruby-2.6.5-0 --checksum 29ef6f1ed911c95ada9710d617438ec90e6e822cae31d2b82d578f9b9e7b1c30
RUN bitnami-pkg install node-10.17.0-1 --checksum 5ba16101794b065df9fe18699e06a1c6fb2350f27c5ca053f2926c7a4099e8fc
RUN bitnami-pkg install mysql-client-10.3.21-0 --checksum 9e012f0e449a963c923c8ea7a5cc2ab2c688564ed910eaab2aef1ad70c5d8e4b
RUN bitnami-pkg install git-2.24.1-0 --checksum ecc3a4f7b7a77ffb00ef66a9b02613c52a5b6d77bf9a5279fa139a66e6265460
RUN bitnami-pkg install rails-6.0.1-0-0 --checksum 80abafc5ce54a5079da815e8eedd93ecee6ebf9d1b813ac7427d815dd33d711b
RUN mkdir /app && chown bitnami:bitnami /app

COPY rootfs /
ENV BITNAMI_APP_NAME="rails" \
    BITNAMI_IMAGE_VERSION="6.0.1-0-ol-7-r29" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:/opt/bitnami/rails/bin:$PATH" \
    RAILS_ENV="development"

EXPOSE 3000

WORKDIR /app
USER bitnami
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000" ]
