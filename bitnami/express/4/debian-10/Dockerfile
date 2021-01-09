FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:/opt/bitnami/sequelize-cli/bin:/opt/bitnami/git/bin:/opt/bitnami/bower/bin:/opt/bitnami/common/bin:/opt/bitnami/express/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl ghostscript gzip imagemagick libbz2-1.0 libc6 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 netcat procps sudo tar zlib1g
RUN /build/bitnami-user.sh
RUN /build/install-nami.sh
RUN bitnami-pkg install node-14.15.4-0 --checksum 1c23a75145fc202950f12bd6cb13a9c9b3ac35a3a09d194c105912d2f4d4a8a6
RUN bitnami-pkg install sequelize-cli-5.5.1-0 --checksum 7e572fea880336f69bf7b0b34cd718ee81e7114fe61313acaba12b7a5564cddc
RUN bitnami-pkg install git-2.30.0-0 --checksum da1ad2f9c18b54f8b382df278b29da9b2c870aae3a16783a740b0d9d28c5e0fb
RUN bitnami-pkg install express-generator-4.16.1-0 --checksum 09dc5947a709a9bbeb257b17cd13bdb2ca87b08fa17baab4583bdc026badef35
RUN bitnami-pkg install bower-1.8.8-0 --checksum 587140d73a26e13c179f65e09b4cd706db000ff9beb68a57f2158aefa86ce4fa
RUN bitnami-pkg install tini-0.19.0-1 --checksum 9b1f1c095944bac88a62c1b63f3bff1bb123aa7ccd371c908c0e5b41cec2528d
RUN bitnami-pkg install gosu-1.12.0-2 --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN bitnami-pkg install express-4.17.1-0 --checksum e90ac676893a1c1edaf31f5bac8b9f951ea00405a6c54613b8e3882ccbad6c3c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
RUN mkdir -p /dist /app /.npm /.config /.cache /.local && chmod g+rwx /dist /app /.npm /.config /.cache /.local
ENV BITNAMI_APP_NAME="express" \
    BITNAMI_IMAGE_VERSION="4.17.1-debian-10-r310" \
    NAMI_PREFIX="/.nami" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

EXPOSE 3000

WORKDIR /app
USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "npm", "start" ]
