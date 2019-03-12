FROM bitnami/oraclelinux-extras:7-r287
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libcurl libgcc libidn libselinux libssh2 libstdc++ nc ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre readline zlib
RUN bitnami-pkg install sequelize-cli-5.4.0-0 --checksum fd012b42fd1d312af4a2ee5153fe2e16092affc4446dcd8afb749d7e6c209395
RUN bitnami-pkg install node-7.10.1-1 --checksum c58b53a2ea5feafe1e0f0ef4b990d9ff55c37089ff5fba12e1938183e8a81a2f
RUN bitnami-pkg install git-2.21.0-0 --checksum 8dc7078aeaa3c3bf7010f3adbdb2f7ec9c3737c7eb6c7c1b2f547350c42fcfa5
RUN bitnami-pkg install express-generator-4.16.0-20 --checksum 96c9120e2e605d7bc6b4553901a17470a4c009a2b580f80adc286e86029c9e3e
RUN bitnami-pkg install express-4.16.4-22 --checksum 424ccebdeb46ced025265fda176284177669062a542a94b55ce7f5b933d6522d
RUN bitnami-pkg install bower-1.8.8-0 --checksum bd1fdb2598234e8506682f57610aaf074ca42e8a1589be555df16e6c6a81dac8
RUN mkdir -p /dist /app /.npm /.config /.cache /.local && chmod g+rwx /dist /app /.npm /.config /.cache /.local

COPY rootfs /
ENV BITNAMI_APP_NAME="express" \
    BITNAMI_IMAGE_VERSION="4.16.4-ol-7-r141" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/sequelize-cli/bin:/opt/bitnami/node/bin:/opt/bitnami/git/bin:/opt/bitnami/express-generator/bin:/opt/bitnami/express/bin:/opt/bitnami/bower/bin:$PATH"

EXPOSE 3000

WORKDIR /app
USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "npm", "start" ]
