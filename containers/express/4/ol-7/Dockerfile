FROM bitnami/oraclelinux-extras:7-r66
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages bzip2-libs glibc keyutils-libs krb5-libs libcom_err libgcc libselinux libstdc++ nc ncurses-libs nss-softokn-freebl openssl-libs pcre readline sqlite zlib
RUN bitnami-pkg install node-7.10.1-1 --checksum c58b53a2ea5feafe1e0f0ef4b990d9ff55c37089ff5fba12e1938183e8a81a2f
RUN bitnami-pkg install express-generator-4.16.0-0 --checksum c7d51fd74deeb5f58b2c6e96ff9343bc80817c9240c937ad01e228322d609463
RUN bitnami-pkg install express-4.16.3-1 --checksum f8d7633ed2081b85afae8d35e0e366bc823fcd85507a151f73fdf176bb38ed71
RUN mkdir -p /dist /app /.npm && chmod g+rwx /app /dist /.npm

COPY rootfs /
ENV BITNAMI_APP_NAME="express" \
    BITNAMI_IMAGE_VERSION="4.16.3-ol-7-r26" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/express-generator/bin:/opt/bitnami/express/bin:$PATH"

EXPOSE 3000

WORKDIR /app
USER 1001
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["npm","start"]
