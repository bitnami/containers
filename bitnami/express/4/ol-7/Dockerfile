FROM bitnami/oraclelinux-extras:7-r586
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libcurl libgcc libidn libselinux libssh2 libstdc++ nc ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre readline sqlite zlib
RUN bitnami-pkg install sequelize-cli-5.5.1-1 --checksum 9e9f7ea62b071b8e745d4d60f79c124e656ef1b2225e790b8109cdac3e5ba106
RUN bitnami-pkg install node-10.18.0-0 --checksum a6119d638448b43f99e18eb4b1a9c9759445b672bb33ae3ce6a7273fa3a7e029
RUN bitnami-pkg install git-2.24.1-0 --checksum ecc3a4f7b7a77ffb00ef66a9b02613c52a5b6d77bf9a5279fa139a66e6265460
RUN bitnami-pkg install express-generator-4.16.1-1 --checksum 4682493da5533b962d138c0386a9dedc189e67db00a50ff4ee2f8e5af9ced7d8
RUN bitnami-pkg install express-4.17.1-1 --checksum c088aba95fd8128f0e1fa3c8bf2d8214c1ac723ca2ef6c4f2bb49f267b4fd5b6
RUN bitnami-pkg install bower-1.8.8-3 --checksum 86565a61a721e74bcb8bc15c7bf858e511369d4a14882384466f76df0588d674
RUN mkdir -p /dist /app /.npm /.config /.cache /.local && chmod g+rwx /dist /app /.npm /.config /.cache /.local

COPY rootfs /
ENV BITNAMI_APP_NAME="express" \
    BITNAMI_IMAGE_VERSION="4.17.1-ol-7-r208" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/sequelize-cli/bin:/opt/bitnami/node/bin:/opt/bitnami/git/bin:/opt/bitnami/express-generator/bin:/opt/bitnami/express/bin:/opt/bitnami/bower/bin:$PATH"

EXPOSE 3000

WORKDIR /app
USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "npm", "start" ]
