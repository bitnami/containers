FROM bitnami/oraclelinux-extras:7-r163
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages bzip2-libs glibc keyutils-libs krb5-libs libcom_err libgcc libselinux libstdc++ nc ncurses-libs nss-softokn-freebl openssl-libs pcre readline zlib
RUN bitnami-pkg install node-7.10.1-1 --checksum c58b53a2ea5feafe1e0f0ef4b990d9ff55c37089ff5fba12e1938183e8a81a2f
RUN bitnami-pkg install express-generator-4.16.0-1 --checksum 4cab970e77ec1d30f40039612295310f6f1de9de81c882b3129209ae11118be0
RUN bitnami-pkg install express-4.16.4-1 --checksum 27dfc61c3ac010c0f2533ce243dc3d985c9b9bc5e9363b437e218464ea116082
RUN mkdir -p /dist /app /.npm && chmod g+rwx /app /dist /.npm

COPY rootfs /
ENV BITNAMI_APP_NAME="express" \
    BITNAMI_IMAGE_VERSION="4.16.4-ol-7-r25" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/express-generator/bin:/opt/bitnami/express/bin:$PATH"

EXPOSE 3000

WORKDIR /app
USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "npm", "start" ]
