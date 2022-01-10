FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbz2-1.0 libc6 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 procps sudo tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.12-11" --checksum 18529e5433b2ff7007527ec2fa5b608cb6432e27ec3e6a9f3ab94fcdb7586475
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.18.2-0" --checksum 5753bbbe5052000888c24ef8c918cfc45577878b03cc4dcfe7d53ea562a48e5a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "sequelize-cli" "5.5.1-1" --checksum 7555275076a12faf13e23da63b3b7b307a883d13faa8c6c36386592a76690c28
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.34.1-0" --checksum 3da2501870c9c3efe8cfa47b7bba894d8d97292a5274b682af1eded3b671641b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "express-generator" "4.16.1-1" --checksum f305084e4b45ac55c2662eef90ff420ea321157c26b6fee3eb1dda51fb56faa0
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "bower" "1.8.12-1" --checksum 00fef2e9e6245631b7049538639b3098922480e5b75d352d90511f8b6c84a80c
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.1-4" --checksum 53c0f1a5361a68c298f31f6701c8e8a026e77f09805d54ecfeb52cf5998d7d06
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "express" "4.17.2-1" --checksum 4d9e9240b47860ed63f79475b537cfce1b6906a847a7049b52841eee73609883
RUN /build/bitnami-user.sh

COPY rootfs /
RUN mkdir -p /dist /app /.npm /.config /.cache /.local && chmod g+rwX /dist /app /.npm /.config /.cache /.local
RUN /opt/bitnami/scripts/express/postunpack.sh
ENV BITNAMI_APP_NAME="express" \
    BITNAMI_IMAGE_VERSION="4.17.2-debian-10-r23" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/sequelize-cli/bin:/opt/bitnami/git/bin:/opt/bitnami/bower/bin:/opt/bitnami/common/bin:/opt/bitnami/express/bin:$PATH"

EXPOSE 3000

WORKDIR /app
ENTRYPOINT [ "/opt/bitnami/scripts/express/entrypoint.sh" ]
CMD [ "npm", "start" ]
