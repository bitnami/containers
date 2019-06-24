FROM bitnami/oraclelinux-extras:7-r377
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libcurl libgcc libidn libselinux libssh2 libstdc++ nc ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre readline sqlite zlib
RUN bitnami-pkg install sequelize-cli-5.5.0-0 --checksum 284287c63e2a2c7375ea3ba70f9a95b2e2ae691a44976fd67d9f90a24d341822
RUN bitnami-pkg install node-10.16.0-0 --checksum f0ed14c08288ec7a8801ae665232750817bf44fd6da43481ea10a6906c44a549
RUN bitnami-pkg install git-2.22.0-0 --checksum 5dc73d3ed8b4f84c89e75fd7c08ec147a528eaf1017946d68c3732748885b3e2
RUN bitnami-pkg install express-generator-4.16.1-0 --checksum a0164cb2836139755197cabc5d7024a447e4bf9531c2cce644725489a18408fb
RUN bitnami-pkg install express-4.17.1-0 --checksum b925ee94227c21fde75a561fd531cdc434c255d243bba368caff60d460a99574
RUN bitnami-pkg install bower-1.8.8-2 --checksum d05201928be17919fa75c1c05adcc4ed23cdfc270f531fea8b491d6706b5fc90
RUN mkdir -p /dist /app /.npm /.config /.cache /.local && chmod g+rwx /dist /app /.npm /.config /.cache /.local

COPY rootfs /
ENV BITNAMI_APP_NAME="express" \
    BITNAMI_IMAGE_VERSION="4.17.1-ol-7-r30" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/sequelize-cli/bin:/opt/bitnami/node/bin:/opt/bitnami/git/bin:/opt/bitnami/express-generator/bin:/opt/bitnami/express/bin:/opt/bitnami/bower/bin:$PATH"

EXPOSE 3000

WORKDIR /app
USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "npm", "start" ]
