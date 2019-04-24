FROM bitnami/minideb-extras:stretch-r352
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libcomerr2 libcurl3 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn11 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libtasn1-6 libtinfo5 libunistring0 netcat zlib1g
RUN bitnami-pkg install sequelize-cli-5.4.0-1 --checksum 23c3be9b4a442e65a6434c70b85ccd14c774b270cc19477abf4e1862b5f6c0e7
RUN bitnami-pkg install node-10.15.3-0 --checksum 6d6c24d3f86c4da3d55ef44c169c011b06120c88e291c233fc14fbf4e78f9578
RUN bitnami-pkg install git-2.21.0-0 --checksum 37eb00d863f94194c0c31464c2c747bc784e662adbab240b5f0ef46b3e259e52
RUN bitnami-pkg install express-generator-4.16.0-22 --checksum c524b61b7e2590f872db1d141daf51f003ad1ee83fa045f62d2d1166085cf22d
RUN bitnami-pkg install express-4.16.4-23 --checksum 38b6ff25d42c14c93f406cf18bacdaacf2a89de8c96604a981d672bc53ecdb7a
RUN bitnami-pkg install bower-1.8.8-2 --checksum 60f4e1edc7b1ce26b521b2b276b9da6136edee188d8edd8e9e6191d23170e033
RUN mkdir -p /dist /app /.npm /.config /.cache /.local && chmod g+rwx /dist /app /.npm /.config /.cache /.local

COPY rootfs /
ENV BITNAMI_APP_NAME="express" \
    BITNAMI_IMAGE_VERSION="4.16.4-debian-9-r176" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/sequelize-cli/bin:/opt/bitnami/node/bin:/opt/bitnami/git/bin:/opt/bitnami/express/bin:/opt/bitnami/bower/bin:$PATH"

EXPOSE 3000

WORKDIR /app
USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "npm", "start" ]
