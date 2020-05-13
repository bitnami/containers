FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/sequelize-cli/bin:/opt/bitnami/node/bin:/opt/bitnami/git/bin:/opt/bitnami/express/bin:/opt/bitnami/bower/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl dirmngr ghostscript gnupg imagemagick libbz2-1.0 libc6 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 netcat procps sudo unzip zlib1g
RUN /build/bitnami-user.sh
RUN /build/install-nami.sh
RUN bitnami-pkg install tini-0.19.0-0 --checksum 9a8ae20be31a518f042fcec359f2cf35bfdb4e2a56f2fa8ff9ef2ecaf45da80c
RUN bitnami-pkg install sequelize-cli-5.5.1-0 --checksum 7e572fea880336f69bf7b0b34cd718ee81e7114fe61313acaba12b7a5564cddc
RUN bitnami-pkg install node-10.20.1-3 --checksum 1d2031e972d160623b392dee30f51b950b31afb39fc4ae8c4579de55d05db976
RUN bitnami-pkg install gosu-1.12.0-0 --checksum 582d501eeb6b338a24f417fededbf14295903d6be55c52d66c52e616c81bcd8c
RUN bitnami-pkg install git-2.26.2-0 --checksum 7d970d7f29ec3ab0ef4c9c699c686ab1b4d95f8371be90cbce07c26b9f4386e7
RUN bitnami-pkg install express-generator-4.16.1-0 --checksum 09dc5947a709a9bbeb257b17cd13bdb2ca87b08fa17baab4583bdc026badef35
RUN bitnami-pkg install express-4.17.1-0 --checksum e90ac676893a1c1edaf31f5bac8b9f951ea00405a6c54613b8e3882ccbad6c3c
RUN bitnami-pkg install bower-1.8.8-0 --checksum 587140d73a26e13c179f65e09b4cd706db000ff9beb68a57f2158aefa86ce4fa
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN mkdir -p /dist /app /.npm /.config /.cache /.local && chmod g+rwx /dist /app /.npm /.config /.cache /.local

COPY rootfs /
ENV BITNAMI_APP_NAME="express" \
    BITNAMI_IMAGE_VERSION="4.17.1-debian-10-r101" \
    NAMI_PREFIX="/.nami"

EXPOSE 3000

WORKDIR /app
USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "npm", "start" ]
