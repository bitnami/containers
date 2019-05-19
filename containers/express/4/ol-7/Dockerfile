FROM bitnami/oraclelinux-extras:7-r341
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libcurl libgcc libidn libselinux libssh2 libstdc++ nc ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre readline sqlite zlib
RUN bitnami-pkg install sequelize-cli-5.4.0-1 --checksum 079954c8be67d58601649b4d6cc5535e335b33406a4773093f43855015e031b8
RUN bitnami-pkg install node-10.15.3-1 --checksum 2309ec0810dbe0cf2ff12c3ae9bdaff723419ffd33774ea21753e29b925262e2
RUN bitnami-pkg install git-2.21.0-0 --checksum 8dc7078aeaa3c3bf7010f3adbdb2f7ec9c3737c7eb6c7c1b2f547350c42fcfa5
RUN bitnami-pkg install express-generator-4.16.1-0 --checksum a0164cb2836139755197cabc5d7024a447e4bf9531c2cce644725489a18408fb
RUN bitnami-pkg install express-4.17.0-0 --checksum 6dc483fac81c7486d4331d3aec9fa1fc3c84dd20d7a6b530a5d9ab020d4be156
RUN bitnami-pkg install bower-1.8.8-2 --checksum d05201928be17919fa75c1c05adcc4ed23cdfc270f531fea8b491d6706b5fc90
RUN mkdir -p /dist /app /.npm /.config /.cache /.local && chmod g+rwx /dist /app /.npm /.config /.cache /.local

COPY rootfs /
ENV BITNAMI_APP_NAME="express" \
    BITNAMI_IMAGE_VERSION="4.17.0-ol-7-r2" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/sequelize-cli/bin:/opt/bitnami/node/bin:/opt/bitnami/git/bin:/opt/bitnami/express-generator/bin:/opt/bitnami/express/bin:/opt/bitnami/bower/bin:$PATH"

EXPOSE 3000

WORKDIR /app
USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "npm", "start" ]
