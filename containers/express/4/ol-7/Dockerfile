FROM bitnami/oraclelinux-extras:7-r470
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libcurl libgcc libidn libselinux libssh2 libstdc++ nc ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre readline sqlite zlib
RUN bitnami-pkg install sequelize-cli-5.5.1-0 --checksum 7e09e539b516505625a541ffae0023498337fa1fdea155ee6aa672d20cbefe46
RUN bitnami-pkg install node-10.16.3-0 --checksum 6d1e5c1738ca06f510ce68bb537b84340dd22871b4cca281df65198f5964ea4a
RUN bitnami-pkg install git-2.23.0-0 --checksum 30618c63e72727b90b3cc3e7f8747e599ec11352b29812285a27029807d8766d
RUN bitnami-pkg install express-generator-4.16.1-0 --checksum a0164cb2836139755197cabc5d7024a447e4bf9531c2cce644725489a18408fb
RUN bitnami-pkg install express-4.17.1-0 --checksum b925ee94227c21fde75a561fd531cdc434c255d243bba368caff60d460a99574
RUN bitnami-pkg install bower-1.8.8-2 --checksum d05201928be17919fa75c1c05adcc4ed23cdfc270f531fea8b491d6706b5fc90
RUN mkdir -p /dist /app /.npm /.config /.cache /.local && chmod g+rwx /dist /app /.npm /.config /.cache /.local

COPY rootfs /
ENV BITNAMI_APP_NAME="express" \
    BITNAMI_IMAGE_VERSION="4.17.1-ol-7-r120" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/sequelize-cli/bin:/opt/bitnami/node/bin:/opt/bitnami/git/bin:/opt/bitnami/express-generator/bin:/opt/bitnami/express/bin:/opt/bitnami/bower/bin:$PATH"

EXPOSE 3000

WORKDIR /app
USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "npm", "start" ]
