FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/sequelize-cli/bin:/opt/bitnami/git/bin:/opt/bitnami/bower/bin:/opt/bitnami/common/bin:/opt/bitnami/express/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libbz2-1.0 libc6 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 netcat procps sudo tar zlib1g
RUN /build/bitnami-user.sh
RUN /build/install-nami.sh
RUN bitnami-pkg install python-3.8.12-4 --checksum 9316a897742995d2df2d9e05cbb6247791f53f792e0681f22c26adb703844ac2
RUN bitnami-pkg install node-14.18.1-0 --checksum 53575c1af09f423b9a2553b8b9880462f192961f4ada8fafa70a0238b106f26a
RUN bitnami-pkg install sequelize-cli-5.5.1-1 --checksum 7555275076a12faf13e23da63b3b7b307a883d13faa8c6c36386592a76690c28
RUN bitnami-pkg install git-2.33.0-0 --checksum fd9a3245580fef6248f778efeba0a017675424f15ff16ace42c095496e4f02f3
RUN bitnami-pkg install express-generator-4.16.1-1 --checksum f305084e4b45ac55c2662eef90ff420ea321157c26b6fee3eb1dda51fb56faa0
RUN bitnami-pkg install bower-1.8.12-0 --checksum a277b2d091258925c65b62ec562ab4dc0846260161b0da8e64d6531840b093db
RUN bitnami-pkg install tini-0.19.0-1 --checksum 9b1f1c095944bac88a62c1b63f3bff1bb123aa7ccd371c908c0e5b41cec2528d
RUN bitnami-pkg install gosu-1.14.0-0 --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN bitnami-pkg install express-4.17.1-3 --checksum ad196d1e8fe95e92fc388b117e1b5b7596074c9238257296411c9086c0f5b249

COPY rootfs /
RUN mkdir -p /dist /app /.npm /.config /.cache /.local && chmod g+rwx /dist /app /.npm /.config /.cache /.local
ENV BITNAMI_APP_NAME="express" \
    BITNAMI_IMAGE_VERSION="4.17.1-debian-10-r562" \
    NAMI_PREFIX="/.nami" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

EXPOSE 3000

WORKDIR /app
USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "npm", "start" ]
