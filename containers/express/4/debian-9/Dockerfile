FROM bitnami/minideb-extras:stretch-r482
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libcomerr2 libcurl3 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn11 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libtasn1-6 libtinfo5 libunistring0 netcat zlib1g
RUN bitnami-pkg install sequelize-cli-5.5.1-0 --checksum ffe979a1d989e96d5416230354eb005c575c5daf02708938566c5395dcb54dbd
RUN bitnami-pkg install node-10.16.3-0 --checksum 6c6466b1645568da237ba1bb079a52ca5661aedcf04d832728890b78a3e48689
RUN bitnami-pkg install git-2.23.0-0 --checksum 54731b0fecdf38ab559cdd76311a229915bf0581b213a5806d3c7d56c5399981
RUN bitnami-pkg install express-generator-4.16.1-0 --checksum 6577ac319892f89db59c4e47464893e995aea20da8873ea42a56f18db2e00a31
RUN bitnami-pkg install express-4.17.1-0 --checksum cb98aa806ede90851b25b2583c22551af1e785db3a07330104e658ebd2bc80c6
RUN bitnami-pkg install bower-1.8.8-2 --checksum 60f4e1edc7b1ce26b521b2b276b9da6136edee188d8edd8e9e6191d23170e033
RUN mkdir -p /dist /app /.npm /.config /.cache /.local && chmod g+rwx /dist /app /.npm /.config /.cache /.local

COPY rootfs /
ENV BITNAMI_APP_NAME="express" \
    BITNAMI_IMAGE_VERSION="4.17.1-debian-9-r114" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/sequelize-cli/bin:/opt/bitnami/node/bin:/opt/bitnami/git/bin:/opt/bitnami/express/bin:/opt/bitnami/bower/bin:$PATH"

EXPOSE 3000

WORKDIR /app
USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "npm", "start" ]
