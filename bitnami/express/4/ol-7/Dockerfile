FROM bitnami/oraclelinux-extras:7-r140
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages bzip2-libs glibc keyutils-libs krb5-libs libcom_err libgcc libselinux libstdc++ nc ncurses-libs nss-softokn-freebl openssl-libs pcre readline sqlite zlib
RUN bitnami-pkg install node-7.10.1-1 --checksum c58b53a2ea5feafe1e0f0ef4b990d9ff55c37089ff5fba12e1938183e8a81a2f
RUN bitnami-pkg install express-generator-4.16.0-0 --checksum c7d51fd74deeb5f58b2c6e96ff9343bc80817c9240c937ad01e228322d609463
RUN bitnami-pkg install express-4.16.4-0 --checksum c1b8d0939c56ecb8bc9d5f2718abbf994eb41d515057ae1981009986c2b72233
RUN mkdir -p /dist /app /.npm && chmod g+rwx /app /dist /.npm

COPY rootfs /
ENV BITNAMI_APP_NAME="express" \
    BITNAMI_IMAGE_VERSION="4.16.4-ol-7-r6" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/express-generator/bin:/opt/bitnami/express/bin:$PATH"

EXPOSE 3000

WORKDIR /app
USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "npm", "start" ]
