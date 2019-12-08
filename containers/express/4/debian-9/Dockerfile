FROM bitnami/minideb-extras:stretch-r494
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libcomerr2 libcurl3 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn11 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libtasn1-6 libtinfo5 libunistring0 netcat zlib1g
RUN bitnami-pkg install sequelize-cli-5.5.1-1 --checksum efb9324dcef35b733fbd0b4eb306c40b0f52e379fcf5064b485d27155c709d00
RUN bitnami-pkg install node-10.17.0-1 --checksum 0b7f3de4f463789d093f5fb9c7647d43f20035714bc48f67aac4faf31f2e4446
RUN bitnami-pkg install git-2.24.0-0 --checksum dee050702e785983e6d45c1ec197c99ffa9f12b38fe5574f53a11c16ba8435ba
RUN bitnami-pkg install express-generator-4.16.1-1 --checksum 3c5f275647d3aea05a7fa26c378f4dd561a276b954cd9506dba77ebec1dea2bf
RUN bitnami-pkg install express-4.17.1-1 --checksum 4a7fd18f6af8e8967c265d79bbdb17c824b091a9d524a9039af9737ada58ef14
RUN bitnami-pkg install bower-1.8.8-3 --checksum 3550c7f19bdf9b1ecebae27e4842947f6ef9ca7851eb49c1b5749e80725047ce
RUN mkdir -p /dist /app /.npm /.config /.cache /.local && chmod g+rwx /dist /app /.npm /.config /.cache /.local

COPY rootfs /
ENV BITNAMI_APP_NAME="express" \
    BITNAMI_IMAGE_VERSION="4.17.1-debian-9-r161" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/sequelize-cli/bin:/opt/bitnami/node/bin:/opt/bitnami/git/bin:/opt/bitnami/express/bin:/opt/bitnami/bower/bin:$PATH"

EXPOSE 3000

WORKDIR /app
USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "npm", "start" ]
