FROM bitnami/oraclelinux-extras:7-r260
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates cyrus-sasl-lib gcc-c++ glibc keyutils-libs krb5-libs libcom_err libcurl libgcc libidn libselinux libssh2 libstdc++ libxml2 make mysql-devel nc ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre pkg-config readline zlib
RUN bitnami-pkg install ruby-2.4.5-20 --checksum f26eeb2bba7058b2327d6587e02911b4f906dbef8275f826e065f39e33bf668b
RUN bitnami-pkg install mysql-client-10.1.38-0 --checksum 8140732986832471cc54aede727b66729811a0fa79e6fa86c7c791ce1f513451
RUN bitnami-pkg install git-2.20.1-20 --checksum 160b41e17f0414c1206e97cc1eef3720596c0229922b68d4ded4a69bfc08cc51
RUN bitnami-pkg install rails-5.2.2-20 --checksum 36a04178c9906755575a7b1af50ff267cab5489d4e9bbebb397c7f690a36036a
RUN mkdir /app && chown bitnami:bitnami /app

COPY rootfs /
ENV BITNAMI_APP_NAME="rails" \
    BITNAMI_IMAGE_VERSION="5.2.2-ol-7-r65" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:/opt/bitnami/rails/bin:$PATH" \
    RAILS_ENV="development"

EXPOSE 3000

WORKDIR /app
USER bitnami
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000" ]
