FROM bitnami/minideb-extras:stretch-r360
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libcomerr2 libcurl3 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn11 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libtasn1-6 libtinfo5 libunistring0 netcat zlib1g
RUN bitnami-pkg install sequelize-cli-5.4.0-1 --checksum 23c3be9b4a442e65a6434c70b85ccd14c774b270cc19477abf4e1862b5f6c0e7
RUN bitnami-pkg install node-10.15.3-1 --checksum 2a07fa553bd4a45f1e68afa0a3e2554806b72ffee5a32e388c12def4e27a51f2
RUN bitnami-pkg install git-2.21.0-0 --checksum 37eb00d863f94194c0c31464c2c747bc784e662adbab240b5f0ef46b3e259e52
RUN bitnami-pkg install express-generator-4.16.1-0 --checksum 6577ac319892f89db59c4e47464893e995aea20da8873ea42a56f18db2e00a31
RUN bitnami-pkg install express-4.16.4-23 --checksum 38b6ff25d42c14c93f406cf18bacdaacf2a89de8c96604a981d672bc53ecdb7a
RUN bitnami-pkg install bower-1.8.8-2 --checksum 60f4e1edc7b1ce26b521b2b276b9da6136edee188d8edd8e9e6191d23170e033
RUN mkdir -p /dist /app /.npm /.config /.cache /.local && chmod g+rwx /dist /app /.npm /.config /.cache /.local

COPY rootfs /
ENV BITNAMI_APP_NAME="express" \
    BITNAMI_IMAGE_VERSION="4.16.4-debian-9-r181" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/sequelize-cli/bin:/opt/bitnami/node/bin:/opt/bitnami/git/bin:/opt/bitnami/express/bin:/opt/bitnami/bower/bin:$PATH"

EXPOSE 3000

WORKDIR /app
USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "npm", "start" ]
