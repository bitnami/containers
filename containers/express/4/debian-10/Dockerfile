FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    PATH="/opt/bitnami/sequelize-cli/bin:/opt/bitnami/node/bin:/opt/bitnami/git/bin:/opt/bitnami/express/bin:/opt/bitnami/bower/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl dirmngr ghostscript gnupg imagemagick libbz2-1.0 libc6 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 netcat procps sudo unzip zlib1g
RUN /build/bitnami-user.sh && \
    /build/install-nami.sh
RUN bitnami-pkg install sequelize-cli-5.5.1-0 --checksum 7e572fea880336f69bf7b0b34cd718ee81e7114fe61313acaba12b7a5564cddc
RUN bitnami-pkg install node-10.19.0-0 --checksum a91f35d97b8219efbe1ae9bc8eda0e0dafa84d738a8eaa0e0e15b599f4fbbff2
RUN bitnami-pkg install git-2.25.1-0 --checksum ca45bb393e1d231affbc8aac5671562af94a92601cc0d7c6b3883fa7bbd20889
RUN bitnami-pkg install express-generator-4.16.1-0 --checksum 09dc5947a709a9bbeb257b17cd13bdb2ca87b08fa17baab4583bdc026badef35
RUN bitnami-pkg install express-4.17.1-0 --checksum e90ac676893a1c1edaf31f5bac8b9f951ea00405a6c54613b8e3882ccbad6c3c
RUN bitnami-pkg install bower-1.8.8-0 --checksum 587140d73a26e13c179f65e09b4cd706db000ff9beb68a57f2158aefa86ce4fa
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN mkdir -p /dist /app /.npm /.config /.cache /.local && chmod g+rwx /dist /app /.npm /.config /.cache /.local
RUN /build/install-gosu.sh
RUN /build/install-tini.sh

COPY rootfs /
ENV BITNAMI_APP_NAME="express" \
    BITNAMI_IMAGE_VERSION="4.17.1-debian-10-r27" \
    NAMI_PREFIX="/.nami"

EXPOSE 3000

WORKDIR /app
USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "npm", "start" ]
