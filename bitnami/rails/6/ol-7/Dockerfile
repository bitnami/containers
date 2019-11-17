FROM bitnami/oraclelinux-extras:7-r532
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates cyrus-sasl-lib gcc-c++ glibc keyutils-libs krb5-libs libcom_err libcurl libgcc libidn libselinux libssh2 libstdc++ libxml2 make mysql-devel nc ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre pkgconfig readline sqlite zlib
RUN bitnami-pkg install ruby-2.6.5-0 --checksum 29ef6f1ed911c95ada9710d617438ec90e6e822cae31d2b82d578f9b9e7b1c30
RUN bitnami-pkg install node-10.17.0-0 --checksum 892c719867dc5d4f495ec2432f9ef6d48151507512d8796c7e56028cf4dee43e
RUN bitnami-pkg install mysql-client-10.3.20-0 --checksum 6e895c7c56273bf724d87014c70187045fa0a399d9f24067e84f27475e3c071a
RUN bitnami-pkg install git-2.24.0-0 --checksum a05099de6d8c26088d81b69c3519e45e481d4605beffaa509eb5b6e6dfed0d90
RUN bitnami-pkg install rails-6.0.1-0-0 --checksum 80abafc5ce54a5079da815e8eedd93ecee6ebf9d1b813ac7427d815dd33d711b
RUN mkdir /app && chown bitnami:bitnami /app

COPY rootfs /
ENV BITNAMI_APP_NAME="rails" \
    BITNAMI_IMAGE_VERSION="6.0.1-0-ol-7-r2" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:/opt/bitnami/rails/bin:$PATH" \
    RAILS_ENV="development"

EXPOSE 3000

WORKDIR /app
USER bitnami
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000" ]
