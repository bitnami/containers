FROM bitnami/oraclelinux-extras:7-r380
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates cyrus-sasl-lib gcc-c++ glibc keyutils-libs krb5-libs libcom_err libcurl libgcc libidn libselinux libssh2 libstdc++ libxml2 make mysql-devel nc ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre pkgconfig readline zlib
RUN bitnami-pkg install ruby-2.6.3-0 --checksum edc7a2d314c592d73272df68e28490846c325d829cdcba97c41fe0fd19edc0f3
RUN bitnami-pkg install mysql-client-10.3.16-0 --checksum bc7ef5b2abef585c0079a7e4cb2a099c5f40cf39402c52078438a39882953ab4
RUN bitnami-pkg install git-2.22.0-0 --checksum 5dc73d3ed8b4f84c89e75fd7c08ec147a528eaf1017946d68c3732748885b3e2
RUN bitnami-pkg install rails-5.2.3-0-0 --checksum 57f3f739ebc3051ee3376f0d8087161a058d67bae8f88a248f457529e7e4ea72
RUN mkdir /app && chown bitnami:bitnami /app

COPY rootfs /
ENV BITNAMI_APP_NAME="rails" \
    BITNAMI_IMAGE_VERSION="5.2.3-0-ol-7-r81" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:/opt/bitnami/rails/bin:$PATH" \
    RAILS_ENV="development"

EXPOSE 3000

WORKDIR /app
USER bitnami
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000" ]
