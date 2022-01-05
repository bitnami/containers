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
RUN bitnami-pkg install python-3.8.12-11 --checksum 18529e5433b2ff7007527ec2fa5b608cb6432e27ec3e6a9f3ab94fcdb7586475
RUN bitnami-pkg install node-14.18.2-0 --checksum 5753bbbe5052000888c24ef8c918cfc45577878b03cc4dcfe7d53ea562a48e5a
RUN bitnami-pkg install sequelize-cli-5.5.1-1 --checksum 7555275076a12faf13e23da63b3b7b307a883d13faa8c6c36386592a76690c28
RUN bitnami-pkg install git-2.34.1-0 --checksum 3da2501870c9c3efe8cfa47b7bba894d8d97292a5274b682af1eded3b671641b
RUN bitnami-pkg install express-generator-4.16.1-1 --checksum f305084e4b45ac55c2662eef90ff420ea321157c26b6fee3eb1dda51fb56faa0
RUN bitnami-pkg install bower-1.8.12-1 --checksum 00fef2e9e6245631b7049538639b3098922480e5b75d352d90511f8b6c84a80c
RUN bitnami-pkg install tini-0.19.0-1 --checksum 9b1f1c095944bac88a62c1b63f3bff1bb123aa7ccd371c908c0e5b41cec2528d
RUN bitnami-pkg install gosu-1.14.0-0 --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN bitnami-pkg install express-4.17.2-0 --checksum 253ee82d80d072c63ca8823d633306df5257370564ecce18f13785e5aa3860fe

COPY rootfs /
RUN mkdir -p /dist /app /.npm /.config /.cache /.local && chmod g+rwx /dist /app /.npm /.config /.cache /.local
ENV BITNAMI_APP_NAME="express" \
    BITNAMI_IMAGE_VERSION="4.17.2-debian-10-r18" \
    NAMI_PREFIX="/.nami" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

EXPOSE 3000

WORKDIR /app
USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "npm", "start" ]
