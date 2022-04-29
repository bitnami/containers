FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbz2-1.0 libc6 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 procps sudo tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.13-3" --checksum a328c8fb3db9e60d3aa19eb7ca31de5da372affcb3d7c0d73610b4a19b634f94
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.19.1-0" --checksum 806082b15c0eb60e4baca497519b4c0cc9cd636d7a944e9943ebc1b9632fabdc
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "sequelize-cli" "6.4.1-0" --checksum a25d0961bd3004d9f098f69ba04317c983ab7c2a2677a61593b13ea3c704fae1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.36.0-0" --checksum 30924cdaed3ea73d8c91a3a460fe917ae14a6a83f1c231c019c2444e6dc517fa
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "express-generator" "4.16.1-8" --checksum 27539ad157fbe90d36b91ef6760d225919ff5e929b4e698e6b051a2c77e1e46e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "bower" "1.8.12-8" --checksum d7bd0d251bb6f7a1ce771bd953c53e4ba7d0bb22ab4f29f92b3e0ba0cbe644bf
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.1-10" --checksum 35c818ba3f4b5aae905959bc7d3a5e81fc63786e3c662b604612c0aa7fcda8fd
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "express" "4.18.1-0" --checksum b1c3d41bbbd41bebba92fe3b87b3d1a6a96bd48a00656eb211cde836b1c2019c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/bitnami-user.sh

COPY rootfs /
RUN mkdir -p /dist /app /.npm /.config /.cache /.local && chmod g+rwX /dist /app /.npm /.config /.cache /.local
RUN /opt/bitnami/scripts/express/postunpack.sh
ENV APP_VERSION="4.18.1" \
    BITNAMI_APP_NAME="express" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/sequelize-cli/bin:/opt/bitnami/git/bin:/opt/bitnami/bower/bin:/opt/bitnami/common/bin:/opt/bitnami/express/bin:$PATH"

EXPOSE 3000

WORKDIR /app
ENTRYPOINT [ "/opt/bitnami/scripts/express/entrypoint.sh" ]
CMD [ "npm", "start" ]
